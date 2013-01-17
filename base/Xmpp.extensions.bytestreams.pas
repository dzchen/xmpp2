unit Xmpp.extensions.bytestreams;

interface
uses
  Jid,XmppUri,Element,SysUtils,Generics.Collections,Xmpp.Client.IQ,System.Classes;
type
  TStreamHost=class(TElement)
  const
  TagName='streamhost';
  private
    function FGetPort:integer;
    procedure FSetPort(value:Integer);
    function FGetHost:string;
    procedure FSetHost(value:string);
    function FGetJid:TJID;
    procedure FSetJid(value:TJID);
    function FGetZeroconf:string;
    procedure FSetZeroconf(value:string);
  public
    constructor Create;overload;override;
    constructor Create(jid:TJID;host:string);overload;
    constructor Create(jid:TJID;host:string;port:Integer);overload;
    constructor Create(jid:TJID;host:string;port:Integer;zeroconf:string);overload;
    property Port:Integer read FGetPort write FSetPort;
    property Host:string read FGetHost write FSetHost;
    property Jid:TJID read FGetJid write FSetJid;
    property Zeroconf:string read FGetZeroconf write FSetZeroconf;
    class function GetConstTagName():string;override;
  end;
  TStreamHostUsed=class(TElement)
  const
  TagName='streamhost-used';
  private
    function FGetJid:TJID;
    procedure FSetJid(value:TJID);
  public
    constructor Create;overload;override;
    constructor Create(jid:TJID);overload;
    property Jid:TJID read FGetJid write FSetJid;
    class function GetConstTagName():string;override;
  end;
  TUdpSuccess=class(TElement)
  const
  TagName='udpsuccess';
  private
    function FGetDestAddr:string;
    procedure FSetDestAddr(value:string);
  public
    constructor Create(dstaddr:string);overload;
    property DestinationAddress:string read FGetDestAddr write FSetDestAddr;
    class function GetConstTagName():string;override;
  end;
  TActivate=class(TElement)
  const
  TagName='activate';
  private
    function FGetJid:TJID;
    procedure FSetJid(jid:TJID);
  public
    constructor Create;overload;override;
    constructor Create(jid:TJID);overload;
    property Jid:TJID read FGetJid write FSetJid;
    class function GetConstTagName():string;override;
  end;
  TByteStream=class(TElement)
  const
  TagName='query';
  private
    function FGetSid:string;
    procedure FSetSid(value:string);
    function FGetMode:string;
    procedure FSetMode(value:string);
    function FGetActivate:TActivate;
    procedure FSetActivate(value:TActivate);
    function FGetStreamHostUsed:TStreamHostUsed;
    procedure FSetStreamHostUsed(value:TStreamHostUsed);
  public
    constructor Create;override;
    property Sid:string read FGetSid write FSetSid;
    property Mode:string read FGetMode write FSetMode;
    function AddStreamHost:TStreamHost;overload;
    function AddStreamHost(sh:TStreamHost):TStreamHost;overload;
    function AddStreamHost(jid:TJid;host:string):TStreamHost;overload;
    function AddStreamHost(jid:TJID;host:string;port:Integer):TStreamHost;overload;
    function AddStreamHost(jid:TJID;host:string;port:Integer;zeroconf:string):TStreamHost;overload;
    function GetStreamHost:TList;
    property Activate:TActivate read FGetActivate write FSetActivate;
    property StreamHostUsed:TStreamHostUsed read FGetStreamHostUsed write FSetStreamHostUsed;
    class function GetConstTagName():string;override;
  end;
  TByteStreamIq=class(TIQ)
  private
    _bytestream:TByteStream;
  public
    constructor Create;overload;override;
    constructor Create(iqtype:string);overload;
    constructor Create(iqtype:string;tojid:TJID);overload;
    constructor Create(iqtype:string;tojid,fromjid:TJID);overload;
    constructor Create(iqtype:string;tojid,fromjid:Tjid;id:string);overload;
    property Query:TByteStream read _bytestream;
  end;
implementation

{ TStreamHost }

constructor TStreamHost.Create(jid: TJID; host: string);
begin
  self.Create;
  self.Jid:=jid;
  self.Host:=host;
end;

constructor TStreamHost.Create;
begin
  inherited;
  Name:='streamhost';
  Namespace:=XMLNS_BYTESTREAMS;
end;

constructor TStreamHost.Create(jid: TJID; host: string; port: Integer);
begin
  Self.Create(jid,host);
  self.Port:=port;
end;

constructor TStreamHost.Create(jid: TJID; host: string; port: Integer;
  zeroconf: string);
begin
  self.Create(jid,host,port);
  self.Zeroconf:=zeroconf;

end;

function TStreamHost.FGetHost: string;
begin
  Result:=GetAttribute('host');
end;

function TStreamHost.FGetJid: TJID;
begin
  if HasAttribute('jid') then
    Result:=tjid.Create(GetAttribute('jid'))
  else
    Result:=nil;
end;

function TStreamHost.FGetPort: integer;
begin
  Result:=strtoint(GetAttribute('port'));
end;

function TStreamHost.FGetZeroconf: string;
begin
  Result:=GetAttribute('zeroconf');
end;

procedure TStreamHost.FSetHost(value: string);
begin
  SetAttribute('host',value);
end;

procedure TStreamHost.FSetJid(value: TJID);
begin
  if value<>nil then
    SetAttribute('jid',value.ToString())
  else
    RemoveAttribute('jid');
end;

procedure TStreamHost.FSetPort(value: Integer);
begin
  SetAttribute('port',inttostr(value));
end;

procedure TStreamHost.FSetZeroconf(value: string);
begin
  SetAttribute('zeroconf',value);
end;

class function TStreamHost.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_BYTESTREAMS;
end;

{ TStreamHostUsed }

constructor TStreamHostUsed.Create;
begin
  inherited;
  Name:='streamhost-used';
  Namespace:=XMLNS_BYTESTREAMS;
end;

constructor TStreamHostUsed.Create(jid: TJID);
begin
  Self.Create;
  self.Jid:=jid;
end;

function TStreamHostUsed.FGetJid: TJID;
begin
  if HasAttribute('jid') then
    Result:=tjid.Create(GetAttribute('jid'))
  else
    Result:=nil;
end;

procedure TStreamHostUsed.FSetJid(value: TJID);
begin
  if value<>nil then
    SetAttribute('jid',value.ToString())
  else
    RemoveAttribute('jid');
end;

class function TStreamHostUsed.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_BYTESTREAMS;
end;

{ TUdpSuccess }

constructor TUdpSuccess.Create(dstaddr: string);
begin
  Name:='udpsuccess';
  Namespace:=XMLNS_BYTESTREAMS;
  self.DestinationAddress:=dstaddr;
end;

function TUdpSuccess.FGetDestAddr: string;
begin
  Result:=GetAttribute('dstaddr');
end;

procedure TUdpSuccess.FSetDestAddr(value: string);
begin
  SetAttribute('dstaddr',value);
end;

class function TUdpSuccess.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_BYTESTREAMS;
end;

{ TActivate }

constructor TActivate.Create;
begin
  inherited;
  Name:='activate';
  Namespace:=XMLNS_BYTESTREAMS;
end;

constructor TActivate.Create(jid: TJID);
begin
  Self.Create;
  Self.Jid:=jid;
end;

function TActivate.FGetJid: TJID;
begin
  if Data='' then
    Result:=nil
  else
    Result:=tjid.Create(Data);
end;

procedure TActivate.FSetJid(jid: TJID);
begin
  if jid<>nil then
    value:=jid.ToString
  else
    value:='';
end;

class function TActivate.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_BYTESTREAMS;
end;

{ TByteStream }

function TByteStream.AddStreamHost(jid: TJid; host: string): TStreamHost;
var
  sh:TStreamHost;
begin
  sh:=TStreamHost.Create(jid,host);
  AddTag(sh);
  Result:=sh;
end;

function TByteStream.AddStreamHost(jid: TJID; host: string;
  port: Integer): TStreamHost;
var
  sh:TStreamHost;
begin
  sh:=TStreamHost.Create(jid,host,port);
  AddTag(sh);
  Result:=sh;
end;

function TByteStream.AddStreamHost: TStreamHost;
var
  sh:TStreamHost;
begin
  sh:=TStreamHost.Create();
  AddTag(sh);
  Result:=sh;
end;

function TByteStream.AddStreamHost(sh: TStreamHost): TStreamHost;
begin
  AddTag(sh);
  Result:=sh;
end;

function TByteStream.AddStreamHost(jid: TJID; host: string; port: Integer;
  zeroconf: string): TStreamHost;
var
  sh:TStreamHost;
begin
  sh:=TStreamHost.Create(jid,host,port,zeroconf);
  AddTag(sh);
  Result:=sh;
end;

constructor TByteStream.Create;
begin
  inherited;
  Name:='query';
  Namespace:=XMLNS_BYTESTREAMS;
end;

function TByteStream.FGetActivate: TActivate;
begin
  Result:=TActivate(GetFirstTag(TActivate.TagName));
end;

function TByteStream.FGetMode: string;
begin
  Result:=GetAttribute('mode');
end;

function TByteStream.FGetSid: string;
begin
  Result:=GetAttribute('sid');
end;

function TByteStream.FGetStreamHostUsed: TStreamHostUsed;
begin
  Result:=TStreamHostUsed(GetFirstTag(TStreamHostUsed.TagName));
end;

procedure TByteStream.FSetActivate(value: TActivate);
begin
  if HasTag(TActivate.TagName) then
    RemoveTag(TActivate.TagName);
  if value<>nil then
    AddTag(value);
end;

procedure TByteStream.FSetMode(value: string);
begin
  if Value<>'none' then
    SetAttribute('mode',value)
  else
    RemoveAttribute('mode');
end;

procedure TByteStream.FSetSid(value: string);
begin
  SetAttribute('sid',value);
end;

procedure TByteStream.FSetStreamHostUsed(value: TStreamHostUsed);
begin
  if HasTag(TStreamHostUsed.TagName) then
    RemoveTag(TStreamHostUsed.TagName);
  if value<>nil then
    AddTag(value);
end;

class function TByteStream.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_BYTESTREAMS;
end;

function TByteStream.GetStreamHost: TList;
begin
  Result:=SelectElements(TStreamHost.TagName);
end;

{ TByteStreamIq }

constructor TByteStreamIq.Create(iqtype: string);
begin
  self.Create;
  self.IqType:=iqtype;
end;

constructor TByteStreamIq.Create;
begin
  inherited;
  _bytestream:=TByteStream.Create;
  FSetQuery(_bytestream);
  GenerateId;
end;

constructor TByteStreamIq.Create(iqtype: string; tojid: TJID);
begin
  self.Create(iqtype);
  self.ToJid:=tojid;
end;

constructor TByteStreamIq.Create(iqtype: string; tojid, fromjid: Tjid;
  id: string);
begin
  self.Create(iqtype,tojid,fromjid);
  self.Id:=id;
end;

constructor TByteStreamIq.Create(iqtype: string; tojid, fromjid: TJID);
begin
  self.Create(iqtype);
  self.ToJid:=tojid;
  self.FromJid:=fromjid;
end;

end.
