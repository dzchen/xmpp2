unit XmppConnection;

interface
uses
SysUtils ,
//{$ifdef linux}
    //QExtCtrls, IdSSLIntercept,
    //{$else}
    windows, ExtCtrls,StrUtils,
    //{endif}
    stringprep,Element,XMPPConst,Xmpp.stream
    ,SyncObjs,xmltag,tcpsynapse,System.Math;
type
  TXmppConnectionStateHandler=procedure(sender:TObject;state:TXmppConnectionState)of object;
  TXmlHandler=procedure(sender:TObject;xml:string)of object;
  TErrorHandler=procedure(sender:TObject;e:string)of object;
  TXmppConnection=class
  private
    _keepalivetimer:TTimer;
    _port:string;
    _server,_connectserver,_streamid,_streamversion:string;
    _connectionstate:TXmppConnectionState;
    _clientsocket:TTCPClient;
    _SocketConnectionType:TSocketConnectionType;
    _autoresolveconnectserver:Boolean;
    _keepaliveinterval:integer;
    _keepalive:Boolean;
    FParser:TXMLTagParser;
    _lock:TCriticalSection;
    FRoot,FRootTag,
    FBuff:string;

    FOnXmppConnectionStateChanged:TXmppConnectionStateHandler;
    FOnReadXml:TXmlHandler;
    FOnWriteXml:TXmlHandler;
    FOnError:TErrorHandler;
//    FOnReadSocketData:OnSocketDataHandler;
//    FOnWriteSocketData:OnSocketDataHandler;
    procedure FSetServer(value:string);
    procedure FSetSocketConnectionType(value:TSocketConnectionType);
    procedure KeepAliveTick(state:TObject);
    procedure InitSocket();

  protected
    procedure CreateKeepAliveTimer();
    procedure DestroyKeepAliveTimer();
    procedure FireOnReadXml(sender:TObject;xml:string);
    procedure FireOnWriteXml(sender:TObject;xml:string);
    procedure FireOnError(sender:TObject;ex:string);


    procedure DoAfterUpgradedToSSL(Sender:TObject);
    procedure DoOnSSLFailed(Sender:TObject;Value:string);

    function  GetFullTag(AData:string):string;
    procedure ProsesData(AData:string);
    procedure ParseTags(AData:string);
    procedure ProsesTags(tag:TXMLTag);virtual;

  public
    procedure DoChangeXmppConnectionState(state:TXmppConnectionState);
    constructor Create();overload;virtual;
    constructor Create(contype:TSocketConnectionType);overload;virtual;
    destructor Destroy;override;
    property Port:string read _port write _port;
    property Server:string read _server write FSetServer;
    property ConnectServer:string read _connectserver write _connectserver;
    property StreamId:string read _streamid write _streamid;
    property StreamVersion:string read _streamversion write _streamversion;
    property XmppConnectionState:TXmppConnectionState read _connectionstate;
    property ClientSocket:TTCPClient read _clientsocket;
    property SocketConnectionType:TSocketConnectionType read _SocketConnectionType write FSetSocketConnectionType;
    property AutoResolveConnectServer:Boolean read _autoresolveconnectserver write _autoresolveconnectserver;
    property KeepAliveInterval:Integer read _keepaliveinterval write _keepaliveinterval;
    property KeepAlive:Boolean read _keepalive write _keepalive;


    property OnXmppConnectionStateChanged:TXmppConnectionStateHandler read FOnXmppConnectionStateChanged write FOnXmppConnectionStateChanged;
    property OnReadXml:TXmlHandler read FOnReadXml write FOnReadXml;
    property OnWriteXml:TXmlHandler read FOnWriteXml write FOnWriteXml;
    property OnError:TErrorHandler read FOnError write FOnError;
//    property OnReadSocketData:OnSocketDataHandler read FOnReadSocketData write FOnReadSocketData;
//    property OnWriteSocketData:OnSocketDataHandler read FOnWriteSocketData write FOnWriteSocketData;


    procedure SocketOnConnect(sender:TObject);virtual;
    procedure SocketOnDisconnect(sender:TObject);virtual;
    procedure SocketOnReceive(sender:TObject; xml:string);virtual;
    //procedure SocketOnBufferReceive(sender:TObject; bt:TBytes;len:Integer);virtual;
    procedure SocketOnError(sender:TObject;Value:string);virtual;
    procedure StreamParserStart(sender:TObject;e:TElement);virtual;
    procedure StreamParserEnd(sender:TObject;xml:string);virtual;
    procedure StreamParserElement(sender:TObject;e:TElement);virtual;
    procedure StreamParserOnStreamError(sender:TObject;e:Exception);virtual;
    procedure StreamParserOnError(sender:TObject;e:string);virtual;
    procedure SocketConnect(); overload;virtual;
    procedure SocketConnect(server:string;port:string);overload;
    procedure SocketDisconnect();
    procedure Send(xml:string);overload;
    procedure Send(el:telement);overload;virtual;
    procedure Open(xml:string);
    procedure Close();virtual;
  end;
  
implementation

{ TXmppConnection }

procedure TXmppConnection.Close;
begin
  Send('</stream:stream>');
end;

constructor TXmppConnection.Create;
begin
  FRootTag := 'stream:stream';
  _port:='5222';
  _streamversion:='1.0';
  _connectionstate:=Disconnected;
  _SocketConnectionType:=Direct;
  _keepaliveinterval:=120;
  _keepalive:=true;
  _lock:=TCriticalSection.Create;
  InitSocket;
  FParser := TXMLTagParser.Create;
end;

constructor TXmppConnection.Create(contype: TSocketConnectionType);
begin
  self.Create;
  _SocketConnectionType:=Direct;
end;

procedure TXmppConnection.CreateKeepAliveTimer;
begin
  if not Assigned(_keepalivetimer) then
  begin
    _keepalivetimer:=TTimer.Create(nil);
    _keepalivetimer.Interval:=_keepaliveinterval*1000;
    _keepalivetimer.OnTimer:=KeepAliveTick;
  end;
  _keepalivetimer.Enabled:=false;
  _keepalivetimer.Enabled:=true;
end;

destructor TXmppConnection.Destroy;
begin
  FreeAndNil(_lock);
  DestroyKeepAliveTimer;
  Close;
  SocketDisconnect;
  
end;

procedure TXmppConnection.DestroyKeepAliveTimer;
begin
  if not Assigned(_keepalivetimer) then
    exit;
  _keepalivetimer.Enabled:=false;
  FreeAndNil(_keepalivetimer);
end;

procedure TXmppConnection.DoAfterUpgradedToSSL(Sender: TObject);
begin

end;

procedure TXmppConnection.DoChangeXmppConnectionState(
  state: TXmppConnectionState);
begin
  _connectionstate:=state;
  if Assigned(FOnXmppConnectionStateChanged) then
    FOnXmppConnectionStateChanged(self,state);
end;

procedure TXmppConnection.DoOnSSLFailed(Sender: TObject; Value: string);
begin

end;

procedure TXmppConnection.FireOnError(sender: TObject; ex: string);
begin
  if Assigned(FOnError) then
    FOnError(sender,ex)
      else
  raise EXMLStream.Create(ex);
end;

procedure TXmppConnection.FireOnReadXml(sender: TObject; xml: string);
begin
  if Assigned(FOnReadXml) then
    FOnReadXml(sender,xml) ;

end;

procedure TXmppConnection.FireOnWriteXml(sender: TObject; xml: string);
begin
  if Assigned(FOnWriteXml) then
    FOnWriteXml(sender,xml);
end;

procedure TXmppConnection.FSetServer(value: string);
begin
  if value<>'' then
    _server:=xmpp_nameprep(value);
end;

procedure TXmppConnection.FSetSocketConnectionType(
  value: TSocketConnectionType);
begin
  _SocketConnectionType:=value;
  InitSocket;
end;

procedure TXmppConnection.InitSocket;
begin

  _clientsocket := TTCPClient.Create;
  _clientsocket.OnConnected := socketonConnect;
  _clientsocket.OnDisconnected := SocketOnDisconnect;
  _clientsocket.OnData := SocketOnReceive;
  _clientsocket.OnError := SocketOnError;
  _clientsocket.OnAfterUpgradedToSSL := DoAfterUpgradedToSSL;
  _clientsocket.OnSSLFailed := DoOnSSLFailed;

end;

procedure TXmppConnection.KeepAliveTick(state: TObject);
begin
  Send(' ');
end;

procedure TXmppConnection.Open(xml: string);
begin
  Send(xml);
end;


// exodus
function TXmppConnection.GetFullTag(AData: string): string;
    function RPos(find_data, in_data: string): cardinal;
    var
        lastpos, newpos: cardinal;
        mybuff: string;
        origlen: cardinal;
    begin
        lastpos := 0;
        newpos := 0;
        origlen := Length(AData);
        repeat
            mybuff := Copy(in_data, lastpos + 1, origlen-newpos);
            newpos := pos(find_data, mybuff);
            if (newpos > 0) then begin
                lastpos := lastpos + newpos;
            end;
        until (newpos <= 0);

        Result := lastpos;
    end;
var
    sbuff, r, stag, etag, tmps: string;
    p, ls, le, e, l, ps, pe, ws, sp, tb, cr, nl, i: longint;
    _counter:integer;
begin
    Result := '';
    _counter := 0;
    sbuff := AData;
    l := Length(sbuff);

    if (Trim(sbuff)) = '' then exit;

    p := Pos('<', sbuff);
    if p <= 0 then
    begin
      fireonerror(self,'Not a valid XML data!');
      Exit;
    end;

    tmps := Copy(sbuff, p, l - p + 1);
    e := Pos('>', tmps);
    i := Pos('/>', tmps);

    if ((e = 0) and (i = 0)) then exit;

    if FRoot = '' then begin
        sp := Pos(' ', tmps);
        tb := Pos(#09, tmps);
        cr := Pos(#10, tmps);
        nl := Pos(#13, tmps);

        ws := sp;
        if (tb > 0) then ws := Min(ws,tb);
        if (cr > 0) then ws := Min(ws,cr);
        if (nl > 0) then ws := Min(ws,nl);

        if ((i > 0) and (i < ws)) then
            FRoot := Trim(Copy(sbuff, p + 1, i - 2))
        else if (e < ws) then
            FRoot := Trim(Copy(sbuff, p + 1, e - 2))
        else
            FRoot := Trim(Copy(sbuff, p + 1, ws - 2));

        if  (FRoot = '?xml') or
            (FRoot = '!ENTITY') or
            (FRoot = '!--') or
            (FRoot = '!ATTLIST') or
            (FRoot = FRootTag) then begin
            r := Copy(sbuff, p, e);
            FRoot := '';
            FBuff := Copy(sbuff, p + e , l - e - p + 1);
            Result := r;
            exit;
        end;
    end;

    if (e = (i + 1)) then begin
        r := Copy(sbuff, p, e);
        FRoot := '';
        FBuff := Copy(sbuff, p + e, l - e - p + 1);
    end
    else begin
        i := p;
        stag := '<' + FRoot;
        etag := '</' + FRoot + '>';
        ls := length(stag);
        le := length(etag);
        r := '';
        repeat
            tmps := Copy(sbuff, i, l - i + 1);
            ps := Pos(stag, tmps);

            if (ps > 0) then begin
                _counter := _counter + 1;
                i := i + ps + ls - 1;
            end;

            tmps := Copy(sbuff, i, l - i + 1);
            pe := RPos(etag, tmps);
            if ((pe > 0) and ((ps > 0) and (pe > ps)) ) then begin
                _counter := _counter - 1;
                i := i + pe + le - 1;
                if (_counter <= 0) then begin
                    r := Copy(sbuff, p, i - p);
                    FRoot := '';
                    FBuff := Copy(sbuff, i, l - i + 1);
                    break;
                end;
            end;
        until ((pe <= 0) or (ps <= 0) or (tmps = ''));
    end;
    result := r;
end;

procedure TXmppConnection.ProsesData(AData: string);
var
  cp_buff: string;
  fc,frag: string;
begin
  cp_buff := AData;
  cp_buff := FBuff + AData;
  FBuff := cp_buff;

  repeat
    frag := GetFullTag(FBuff);
    if (frag <> '') then
    begin
      fc := frag[2];
      if (fc <> '?') and (fc <> '!') then
        ParseTags(frag);
      FRoot := '';
    end;
  until ((frag = '') or (FBuff = ''));
end;

procedure TXmppConnection.ProsesTags(tag: TXMLTag);
begin
  //FireOnReadXml(self, tag.xml);
  if tag.Name=FRootTag then
  begin
    StreamParserStart(self,TElement(tag));
  end
  else
    StreamParserElement(self,TElement(tag));
end;

procedure TXmppConnection.ParseTags(AData: string);
var
  c_tag: TXMLTag;
begin
  FParser.ParseString(AData, FRootTag);
//  repeat
    c_tag := FParser.PopTag;
    if (c_tag <> nil) then
    begin
      ProsesTags(c_tag);
      c_tag.Free;
    end;
//  until (c_tag = nil);
end;

procedure TXmppConnection.SocketConnect;
begin
  DoChangeXmppConnectionState(Connecting);
  _clientsocket.Connect();
end;

procedure TXmppConnection.Send(el: telement);
begin
  Send(el.xml);
end;

procedure TXmppConnection.Send(xml: string);
var
  bt:tbytes;
begin
  FireOnWriteXml(Self,xml);
  _clientsocket.Senddata(xml);
  if _keepalive and (not Assigned(_keepalivetimer)) then
    CreateKeepAliveTimer;
end;

procedure TXmppConnection.SocketConnect(server: string; port: string);
begin
  _clientsocket.Host:=server;
  _clientsocket.Port:=port;
  SocketConnect;
end;

procedure TXmppConnection.SocketDisconnect;
begin
  _clientsocket.Disconnect;
end;


procedure TXmppConnection.SocketOnConnect(sender: TObject);
begin
  DoChangeXmppConnectionState(Connected);
end;

procedure TXmppConnection.SocketOnDisconnect(sender: TObject);
begin

end;

procedure TXmppConnection.SocketOnError(sender: TObject; Value:string);
begin

end;

procedure TXmppConnection.SocketOnReceive(sender: TObject; xml:string);
var
  el:TElement;
  bt:TBytes;
begin

  if Pos('<',xml)>0 then
  begin
{$IFDEF DEBUG_XML}
    if Assigned(OnDebugXML) then
      FOnDebugXML(Self,'<= '+Value);
{$ENDIF}
    if (xml<>('</'+FRootTag+'>')) then
      ProsesData(xml)
    else
      StreamParserEnd(self,xml);
  end;

end;

procedure TXmppConnection.StreamParserOnError(sender: TObject; e: string);
begin
  FireOnError(self,e);
end;

procedure TXmppConnection.StreamParserElement(sender: TObject;
  e: TElement);
begin
  FireOnReadXml(Self,e.xml);
end;

procedure TXmppConnection.StreamParserEnd(sender: TObject; xml:string);
begin
  FireOnReadXml(self,xml);
end;

procedure TXmppConnection.StreamParserOnStreamError(sender: TObject;
  e: Exception);
begin

end;

procedure TXmppConnection.StreamParserStart(sender: TObject;
  e: TElement);
var
  xml:string;
  st:xmpp.stream.TStream;
begin
  xml:=e.xml;
  xml:=AnsiMidStr(xml,1,Length(xml)-1)+'>';
  FireOnReadXml(self,xml);
  st:=xmpp.stream.TStream(e);
  if st<>nil then
  begin
    _streamid:=st.StreamId;
    _streamversion:=st.Version;
  end;
end;



end.
