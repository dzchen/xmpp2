unit XmppClientConnection;

interface
uses
  XmppConnection,Xmpp.iq.Agentiq,Generics.Collections,IqGrabber,PresenceGrabber,MessageGrabber
  ,xmpp.client.PresenceManager,Jid,xmpp.client.IQ,Element,XMPPConst,stringprep,Xmpp.iq.Auth,Xmpp.iq.Register,Xmpp.iq.RegisterEventArgs
  ,Xmpp.iq.Roster,Xmpp.iq.AuthIq,Xmpp.iq.RosterIq
  ,xmpp.client.Presence,Xmpp.iq.DiscoInfo,xmpp.extensions.Capabilities,xmpp.client.Message,xmpp.stream.Features
  ,xmpp.extensions.Compress,xmpp.tls.StartTls,xmpp.stream.Error,xmpp.Stream
  ,Xmpp.iq.RosterItem,XmppVCardManager,RosterManager,XmppClientExtension
  ,classes,SysUtils,StrUtils,XMPPEvent,Xmpp.Client.sasl.SaslEventArgs,Xmpp.Client.sasl.SaslHandler;
const
  SRV_RECORD_PREFIX='_xmpp-client._tcp.';

type
  TConnectTimeoutException=class(Exception)
  public
    constructor Create(const msg:string);
  end;

  TXmppClientConnection=class(TXmppConnection)
  private
    _cleanupdone,_streamstarted,_usesso:Boolean;
    _clientlanguage,_serverlanguage,_username,_password,_resource,_status,_KerberosPrincipal:string;
    _priority:integer;
    _show:string;
    _autoroster,_autoagents,_autopresence,_autoacceptsubscription,_usessl,_usestarttls,_usecompress,_binded,_authenticated:Boolean;
    _iqgrabber:TIqGrabber;
    _messagegrabber:TMessageGrabber;
    _presencegrabber:TPresenceGrabber;
    _registeraccount:Boolean;

    _capabilities:TCapabilities;
    _clientversion:string;
    _enablecapabilities:Boolean;
    _discoinfo:TDiscoInfo;
    _saslhandler:tsaslhandler;
    _extentions:TList;


    FOnLogin,FOnBinded,FOnRegistered,FOnPasswordChanged,FOnClose
    ,FOnAgentStart,FOnAgentEnd,FOnSaslEnd:tnotifyevent;
    FOnRegisterError,FOnStreamError,FOnAuthError:TXmppElementHandler;
    FOnSocketError:TErrorHandler;

    FOnIq:TIqHandler;
    FOnMessage:Tmessagehandler;

    FOnAgentItem:TAgentHandler;
    FOnRegisterInformation:TRegisterEventHandler;
    FOnSaslStart:TSaslEventHandler;
    FVCardManager:TXmppVCardManager;
    _rostermanager:TRosterManager;

    procedure FSetUsername(value:string);
    procedure FSetPriority(value:integer);
    procedure FSetUseSSL(value:Boolean);
    procedure FSetUseStartTLS(value:Boolean);

    procedure _Open();
    procedure OpenSoket();
    procedure ResolveSrv();
    procedure SetConnectServerFromSRVRecords();
//    procedure RemoveSrvRecord(rec:TSRVRecord);
//    function PickSRVRecord():TSRVRecord;
    procedure SendStreamHeader(startParser:Boolean);

    procedure OnChangePasswordResult(sender:TObject;iq:TIQ;const data:Pointer);
    procedure GetRegistrationFields(data:TElement);
    procedure OnRegistrationFieldsResult(sender:TObject;iq:TIQ;const data: pointer);
    procedure OnRegisterResult(sender:TObject;iq:TIQ;const data: pointer);
    procedure OnGetAuthInfo(sender:TObject;iq:TIQ;const data: pointer);
    function BuildMyJid():TJID;
    procedure OnAgents(sender:TObject;iq:TIQ;const data: pointer);
    procedure OnAuthenticate(sender:TObject;iq:TIQ;const data: pointer);
    procedure InitSaslHandler();
    procedure CleanupSession();
    procedure saslHandler_OnSaslEnd(sender:TObject);
    procedure saslhandler_OnSaslStart(sender:TObject;args:TSaslEventArgs);
  public
    procedure RaiseOnLogin();
    procedure FireOnAuthError(e:TElement);
    procedure Reset();
    procedure RequestLoginInfo();
    procedure DoRaiseEventBinded();
    property ClientLanguage:string read _clientlanguage write _clientlanguage;
    property ServerLanguage:string read _serverlanguage;
    property UserName:string read _username write FSetUsername;
    property Password:string read _password write _password;
    property Resource:string read _resource write _resource;
    property MyJID:TJID read BuildMyJid;
    property Status:string read _status write _status;
    property Priority:Integer read _priority write FSetPriority;
    property Show:string read _show write _show;
    property AutoRoster:Boolean read _autoroster write _autoroster;
    property AutoPresence:Boolean read _autopresence write _autopresence;
    property AutoAcceptSubscription:boolean  read _autoacceptsubscription write _autoacceptsubscription;
    property AutoAgents:Boolean read _autoagents write _autoagents;
    property UseSso:boolean read _usesso write _usesso;
    property KerberosPrincipal:string read _KerberosPrincipal write _KerberosPrincipal;
    property UseSSL:Boolean read _usessl write FSetUseSSL;
    property UseStartTLS:Boolean read _usestarttls write FSetUseStartTLS;
    property UseCompression:Boolean read _usecompress write _usecompress;
    property Authenticated:Boolean read _authenticated;
    property Binded:Boolean read _binded write _binded;
    property RegisterAccount:Boolean read _registeraccount write _registeraccount;
    property IqGrabber:TIqgrabber read _iqgrabber;
    property MessageGrabber:TMessageGrabber read _messagegrabber;
    property PresenceGrabber:TPresenceGrabber read _presencegrabber;

    property EnableCapabilities:Boolean read _enablecapabilities write _enablecapabilities;
    property ClientVersion:string read _clientversion write _clientversion;
    property Capabilities:TCapabilities read _capabilities write _capabilities;
    property DiscoInfo:TDiscoInfo read _discoinfo write _discoinfo;

    property OnLogin:TNotifyEvent read FOnLogin write FOnLogin;
    property OnAuthError:TXmppElementHandler read FOnAuthError write FOnAuthError;
    property OnBinded:TNotifyEvent read FOnBinded write FOnBinded;
    property OnRegisterInformation:TRegisterEventHandler read FOnRegisterInformation write FOnRegisterInformation;

    property OnIq:TIqHandler read FOnIq write FOnIq;
    property OnMessage:TMessageHandler read FOnMessage write FOnMessage;
    property OnClose:TNotifyEvent read FOnClose write FOnClose;
    property OnSaslEnd:TnotifyEvent read FOnSaslEnd write FOnSaslEnd;
    property OnSaslStart:TSaslEventHandler read FOnSaslStart write FOnSaslStart;
    property  Extensions:TList  read _extentions write _extentions;
    property vCardManager:TXmppVCardManager  read  FvCardManager write FvCardManager;
    property RosterManager:TRosterManager read _rostermanager;
    constructor Create;overload;override;
    constructor Create(sockettype:TSocketConnectionType);overload;override;
    constructor Create(server:string);overload;
    constructor Create(server:string;port:string);overload;
    procedure Open();overload;
    procedure Open(UserName,password:string);overload;
    procedure Open(UserName,password,resource:string);overload;
    procedure Open(UserName,password,resource:string;priority:Integer);overload;
    procedure Open(UserName,password:string;priority:Integer);overload;
    procedure SocketOnConnect(sender:Tobject);override;
    procedure SocketOnDisconnect(sender:Tobject);override;
    procedure SocketOnError(sender:TObject;ex:string);override;
    procedure SendMyPresence();
    procedure UpdateCapsVersion();
    procedure ChangePassword(newpass:string);
    procedure RequestAgents();
    procedure RequestRoster();
    procedure StreamParserStart(sender:TObject;e:TElement);override;
    procedure StreamParserEnd(sender:TObject;xml:string);override;
    procedure StreamParserElement(sender:TObject;e:TElement);override;
    procedure StreamParserOnStreamError(sender:TObject;ex:Exception);override;
    procedure Send(e:TElement);override;
    procedure AddExtention(ext:TXmppClientExtension);
    procedure RemoveExtention(ext:TXmppClientExtension);

  end;
  


implementation

{ TXmppClientConnection }

constructor TXmppClientConnection.Create;
begin
  inherited Create;
  _capabilities:=TCapabilities.Create;
  _discoinfo:=TDiscoInfo.Create;
  _clientlanguage:='en';
  _resource:='agsXMPP';
  _autoroster:=True;
  _autoagents:=true;
  _autopresence:=true;
  _usestarttls:=true;
  _clientversion:='0.1';
  _show:='NONE';
  _saslhandler:=nil;
//  oniq:=TIqHandler.create();
//  OnMessage:=TEventList<MessageHandler>.create();
//  OnPresence:=TEventList<PresenceHandler>.create();
  _iqgrabber:=TIqGrabber.Create(self);
  _messagegrabber:=TMessageGrabber.Create();
  _presencegrabber:=TPresenceGrabber.Create(self);

  _rosterManager:=TRosterManager.create(Self);
  _extentions:=tlist.Create;
  FvCardManager := TXmppVCardManager.create(Self);
  AddExtention(FvCardManager);
end;

procedure TXmppClientConnection.AddExtention(ext: TXmppClientExtension);
begin
  if _extentions.indexof(ext)>=0 then
  begin

  end
  else
  begin
    _extentions.add(ext);
  end;
end;

function TXmppClientConnection.BuildMyJid: TJID;
var
  j:TJid;
begin
  j:=TJID.Create('');
  j.user:=_username;
  j.domain:=Server;
  j.resource:=_resource;
  j.BuildJid();
  Result:=j;
end;

procedure TXmppClientConnection.ChangePassword(newpass: string);
var
  regiq:TRegisterIq;
begin
  regiq:=TRegisterIq.Create('set',TJID.Create(Server));
  regiq.Query.Username:=_username;
  regiq.Query.Password:=newpass;
  IqGrabber.SendIq(TIQ(regiq),OnChangePasswordResult,Pointer(newpass));
  regiq:=nil;
end;

procedure TXmppClientConnection.CleanupSession;
begin
  _cleanupdone:=true;
  if ClientSocket.IsConnected then
    ClientSocket.Disconnect;
  dochangexmppconnectionstate(Disconnected);
  //StreamParser.Reset;
  _iqgrabber.Clear;
  _messagegrabber.Clear;
  if Assigned(_saslhandler) then
  begin
    freeandnil(_saslhandler);
  end;
  _authenticated:=False;
  _binded:=False;
  DestroyKeepAliveTimer;
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

constructor TXmppClientConnection.Create(server: string; port: string);
begin
  Self.Create;
  Self.Server:=server;
  self.port:=port;
end;

constructor TXmppClientConnection.Create(server: string);
begin
  Self.Create;
  Self.Server:=server;
end;

constructor TXmppClientConnection.Create(sockettype: TSocketConnectionType);
begin
  Self.Create;
  Self.SocketConnectionType:=sockettype;
end;

procedure TXmppClientConnection.DoRaiseEventBinded;
begin
  if Assigned(FOnBinded) then
    FOnBinded(Self);
end;

procedure TXmppClientConnection.FireOnAuthError(e: TElement);
begin
  if Assigned(FOnAuthError) then
    FOnAuthError(Self,e);
end;

procedure TXmppClientConnection.FSetPriority(value: integer);
begin
  if (value>-128) and (value<128) then
    _priority:=value
  else
    raise EArgumentException.Create('The value MUST be an integer between -128 and +127');
end;

procedure TXmppClientConnection.FSetUsername(value: string);
var
  s:string;
begin
  _username:=value;
  s:=TJID.applyJEP106(value);
  if value<>'' then
    _username:= xmpp_nodeprep(s)
  else
    _username:='';
end;

procedure TXmppClientConnection.FSetUseSSL(value: Boolean);
begin
  _usessl:=value;
  if value then
    _usestarttls:=False;
end;

procedure TXmppClientConnection.FSetUseStartTLS(value: Boolean);
begin
  _usestarttls:=value;
  if value then
    _usessl:=False;
end;

procedure TXmppClientConnection.GetRegistrationFields(data: TElement);
var
  regiq:TRegisterIq;
begin
   regIq := TRegisterIq.Create('get', TJid.Create(Server));
   IqGrabber.SendIq(regIq, OnRegistrationFieldsResult, Pointer(data));
   regiq:=nil;
end;

procedure TXmppClientConnection.InitSaslHandler;
begin
  if not Assigned(_saslhandler) then
  begin
    _saslhandler:=tsaslhandler.create(self);
    _saslhandler.onsaslstart:=SaslHandler_OnSaslStart;
    _SaslHandler.OnSaslEnd:=SaslHandler_OnSaslEnd;

  end;
end;

procedure TXmppClientConnection.OnAgents(sender: TObject; iq: TIQ;
  const data: pointer);
var
  ag,a:TAgents;
  al:tlist;
  i:integer;
begin
  if Assigned(FOnAgentStart) then
    FOnAgentStart(Self);
  ag:=TAgents(iq.Query);
  if(ag<>nil)then
  begin
    al:=TList.Create;
    ag.getagents(al);
    for i := 0 to al.Count-1 do
    begin
      if Assigned(FOnAgentItem) then
        FOnAgentItem(self,al[i]);
    end;

  end;
  if Assigned(FOnAgentEnd) then
    FOnAgentEnd(Self);
end;

procedure TXmppClientConnection.OnAuthenticate(sender: TObject; iq: TIQ;
  const data: pointer);
begin
  if iq.IqType='result' then
  begin
    _authenticated:=True;
    RaiseOnLogin;
  end
  else if iq.IqType='error' then
  begin
    if Assigned(FOnAuthError) then
      FOnAuthError(self,iq);
  end;
end;

procedure TXmppClientConnection.OnChangePasswordResult(sender: TObject; iq: TIQ;
  const data:Pointer);
begin
  if iq.IqType='result' then
  begin
    if Assigned(FOnPasswordChanged) then
      FOnPasswordChanged(Self);
    _password:=string(data^);
  end else if iq.IqType='error' then
  begin
    if Assigned(FOnRegisterError) then
      FOnRegisterError(self,iq);
  end;
end;

procedure TXmppClientConnection.OnGetAuthInfo(sender: TObject; iq: TIQ;
  const data: pointer);
var
  auth:Tauth;
begin
  iq.GenerateId;
  iq.SwitchDirection;
  iq.IqType:='set';
  auth:=TAuth(iq.Query);
  auth.Resource:=_resource;
  auth.SetAuth(_username,_password,StreamId);
  IqGrabber.SendIq(iq,onauthenticate,nil);
  auth:=nil;

end;

procedure TXmppClientConnection.OnRegisterResult(sender: TObject; iq: TIQ;
  const data: pointer);
begin
  if iq.IqType='result' then
  begin
    DoChangeXmppConnectionState(txmppconnectionstate.Registered);
    if Assigned(FOnRegistered) then
      FOnRegistered(Self);
    if (StreamVersion='') and (LeftStr(StreamVersion,2)='1.') then
    begin
      InitSaslHandler;
       StreamParserElement(self, data);
    end
    else
      RequestLoginInfo;
  end
  else if iq.IqType='error' then
  begin
    if Assigned(FOnRegisterError) then
      FOnRegisterError(Self,iq);
  end;
end;

procedure TXmppClientConnection.OnRegistrationFieldsResult(sender: TObject;
  iq: TIQ; const data: pointer);
var
  args:TRegisterEventArgs;
  regiq:TIQ;
  reg:TRegister;
begin
  if iq.IqType<>'error' then
  begin
    if (iq.Query<>nil) and (iq.Query is TRegister) then
    begin
      args:=TRegisterEventArgs.create(TRegister(iq.query));
      if Assigned(fonregisterinformation) then
         fonregisterinformation(self,args);
      dochangexmppconnectionstate(registering);
      regiq:=tiq.create('set');
      regiq.GenerateId;
      regiq.ToJid:=tjid.Create(Server);
      if args.Auto then
      begin
        reg:=TRegister.Create(_username,_password);
        regiq.Query:=reg;
      end
      else
        regiq.Query:=args.Reg;
      IqGrabber.SendIq(regiq,onregisterresult,nil);
      regiq:=nil;
    end;
  end
  else
    if Assigned(FOnRegisterError) then
      FOnRegisterError(self,iq);
end;


procedure TXmppClientConnection.Open(UserName, password, resource: string);
begin
  _username:=UserName;
  _password:=password;
  _resource:=resource;
  _open;
end;

procedure TXmppClientConnection.Open(UserName, password: string);
begin
  _username:=UserName;
  _password:=password;
  _open;
end;

procedure TXmppClientConnection.Open;
begin
  _Open;
end;

procedure TXmppClientConnection.Open(UserName, password, resource: string;
  priority: Integer);
begin
  _username:=UserName;
  _password:=password;
  _resource:=resource;
  _priority:=priority;
  _open;
end;

procedure TXmppClientConnection.Open(UserName, password: string;
  priority: Integer);
begin
  username:=UserName;
  _password:=password;
  _priority:=priority;
  _open;
end;

procedure TXmppClientConnection.OpenSoket;
begin
  if ConnectServer='' then
    SocketConnect(Server,Port)
  else
    SocketConnect(ConnectServer,Port);
end;

procedure TXmppClientConnection.RaiseOnLogin;
begin
  if KeepAlive then
    CreateKeepAliveTimer;
  if Assigned(FOnLogin) then
    FOnLogin(Self);
  if _autoagents then
    RequestAgents;
  if _autoroster then
    RequestRoster;
end;

procedure TXmppClientConnection.RemoveExtention(ext: TXmppClientExtension);
begin
  if _extentions.indexof(ext)>=0 then
  begin
    _extentions.remove(ext);
    freeandnil(ext);
  end;
end;

procedure TXmppClientConnection.RequestAgents;
var
  iq:tagentsiq;
begin
  iq:=tagentsiq.create('get',TJID.Create(Server));
  IqGrabber.SendIq(iq,onagents,nil);
  iq:=nil;
end;

procedure TXmppClientConnection.RequestLoginInfo;
var
  iq:TauthIq;
begin
  iq:=TAuthIq.Create('get',TJID.Create(Server));
  iq.Query.Username:=_username;
  IqGrabber.SendIq(iq,ongetauthinfo,nil);
  iq:=nil;
end;

procedure TXmppClientConnection.RequestRoster;
var
  iq:TRosterIq;
begin
  iq:=trosteriq.create('get');
  Send(iq);
  iq:=nil;
end;

procedure TXmppClientConnection.Reset;
begin
  //ClientSocket.reset();
  //StreamParser.Reset();
  SendStreamHeader(false);
end;

procedure TXmppClientConnection.ResolveSrv;
begin

end;

procedure TXmppClientConnection.saslHandler_OnSaslEnd(sender: TObject);
begin
  if Assigned(fonsaslend) then
    fonsaslend(self);
  _authenticated:=true;
end;

procedure TXmppClientConnection.saslhandler_OnSaslStart(sender: TObject;
  args: TSaslEventArgs);
begin
  if Assigned(fonsaslstart) then
    fonsaslstart(self,args);
end;

procedure TXmppClientConnection.Send(e: TElement);
begin
  inherited Send(e);
end;

procedure TXmppClientConnection.SendMyPresence;
var
  pres:TPresence;
begin
  pres:=TPresence.Create(_show,_status,_priority);
  if _enablecapabilities then
  begin
    if _capabilities.Version='' then
      UpdateCapsVersion;
    pres.AddTag(_capabilities);
  end;
  send(pres);
  pres:=nil;
end;

procedure TXmppClientConnection.SendStreamHeader(startParser: Boolean);
var
  s:string;
begin
  s:='<stream:stream to='''+server+''' xmlns=''jabber:client'' xmlns:stream=''http://etherx.jabber.org/streams''';
  if StreamVersion<>'' then
    s:=s+' version='''+streamversion+'''';
  if _clientlanguage<>'' then
    s:=s+' xml:lang='''+_clientlanguage+'''';
  s:=s+'>';
  Open(s);
  //Sleep(10);
  //Open(s);
end;

procedure TXmppClientConnection.SetConnectServerFromSRVRecords;
begin

end;

procedure TXmppClientConnection.SocketOnConnect(sender: Tobject);
begin
  inherited SocketOnConnect(sender);
  SendStreamHeader(true);
end;

procedure TXmppClientConnection.SocketOnDisconnect(sender: Tobject);
begin
  inherited SocketOnDisconnect(sender);
  if not _cleanupdone then
    CleanupSession;
end;

procedure TXmppClientConnection.SocketOnError(sender: TObject; ex: string);
begin
  inherited SocketOnError(sender,ex);
//  if ex is TConnectTimeoutException then
//  begin
//  OpenSoket;
//  end
//  else
  begin
    if Assigned(FOnSocketError) then
      FOnSocketError(self,ex);
    if _streamstarted and (not _cleanupdone) then
      CleanupSession;
  end;
end;

procedure TXmppClientConnection.StreamParserElement(sender: TObject;
  e: TElement);
var
  iq:TIQ;
  f:TFeatures;
  i:integer;
begin
  inherited StreamParserElement(sender,e);
  if e.Name='iq' then
  begin
      iq:=TIQ(e);
    if Assigned(FOnIq) then
    begin
        FOnIq(Self,iq);
    end;
      if (iq<>nil) and (iq.Query<>nil) then
        if iq.Query.Namespace=TRoster.NameSpace then
        begin
          if _autopresence and (iq.IqType='result') then
            SendMyPresence;
        end;
    _iqgrabber.OnIq(sender,iq);
  end
  else if e.Name=(TMessage.TagName) then
  begin
    if Assigned(fonmessage) then
    begin
        fonmessage(Self,TMessage(e));
    end;
    _messagegrabber.OnMessage(sender,TMessage(e));
  end
  else if e.name=(TPresence.TagName) then
  begin
    TRosterManager(_rostermanager).OnPresence(sender,TPresence(e));
    _presencegrabber.OnPresence(sender,TPresence(e));
  end
  else if e.IsTagEqual(TFeatures.TagName) then
  begin
    f:=TFeatures(e);
    if _usecompress and f.SupportsCompression and f.Compression.SupportsMethod('zlib') then
    begin
      DoChangeXmppConnectionState(StartCompression);
      Send(TCompress.Create('zlib'));
    end
    else if f.SupportsStartTls and _usestarttls then
    begin
      DoChangeXmppConnectionState(Securing);
      Send(TStartTls.create);
    end
    else if f.SupportsRegistration and _registeraccount then
    begin
      if f.SupportsRegistration then
        GetRegistrationFields(e)
      else
      begin
        FireOnError(Self,('Registration is not allowed on this server'));
        Close;
      end;
    end;

  end
  else if e.name=(TProceed.TagName) then
  begin
    //StreamParser.reset();
    ClientSocket.DoOpenSSL;
    //SendStreamHeader(false);
    //Sleep(1);
    SendStreamHeader(false);
    DoChangeXmppConnectionState(Authenticating);
  end
  else if e.name=(TCompressed.TagName) then
  begin
    //StreamParser.reset;
    //ClientSocket.startcompression;
    SendStreamHeader(false);
    DoChangeXmppConnectionState(Compressed);
  end
  else if e.name=(TError.TagName) then
  begin
    if Assigned(FOnStreamError) then
      FOnStreamError(self,e);
  end;
    if assigned(_saslhandler) then
  _saslhandler.OnStreamElement(sender,e);
  for i := 0 to _extentions.Count-1 do
  begin
    if(TXmppClientExtension(_extentions[i]).StreamParserElement(sender,e))then
    break;
  end;
       
end;

procedure TXmppClientConnection.StreamParserEnd(sender: TObject;
  xml:string);
begin
  inherited StreamParserEnd(sender,xml);
  if not _cleanupdone then
    CleanupSession;
end;

procedure TXmppClientConnection.StreamParserOnStreamError(sender: TObject;
  ex: Exception);
begin
  inherited StreamParserOnStreamError(self,ex);
  SocketDisconnect;
  CleanupSession;
  FireOnError(Self,ex.Message);
  if not _cleanupdone then
    CleanupSession;

end;

procedure TXmppClientConnection.StreamParserStart(sender: TObject;
  e: TElement);
var
  st:xmpp.stream.TStream;
begin
  inherited StreamParserStart(sender,e);
  _streamstarted:=true;
  st:=xmpp.stream.TStream(e);
  if st=nil then
    exit;
  _serverlanguage:=st.Language;
  if not RegisterAccount then
  begin
    if (StreamVersion<>'') and StartsText('1.',StreamVersion) then
    begin
      if not Authenticated then
        InitSaslHandler;
    end
    else
      RequestLoginInfo;
  end
  else
  begin
    if StreamVersion='' then
      GetRegistrationFields(TElement(nil));
  end;
end;

procedure TXmppClientConnection.UpdateCapsVersion;
begin
  _capabilities.SetVersion(_discoinfo);
end;

procedure TXmppClientConnection._Open;
begin
  _cleanupdone:=false;
  _streamstarted:=False;
  //StreamParser.Reset;
  //ClientSocket.SSL:=_usessl;
  if (SocketConnectionType=TSocketConnectionTYpe.Direct) and AutoResolveConnectServer then
    ResolveSrv;
  OpenSoket;

end;

{ TConnectTimeoutException }

constructor TConnectTimeoutException.Create(const msg: string);
begin
  inherited Create(msg);
end;



end.
