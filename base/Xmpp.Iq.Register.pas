unit Xmpp.Iq.Register;

interface
uses
  Element,XmppUri,Xmpp.x.Data,Xmpp.Client.IQ,Jid ;
type
  TRegister=class(TElement)
  const
  TagName='query';
  private
    function FGetUsername:string;
    procedure FSetUsername(value:string);
    function FGetPassword:string;
    procedure FSetPassword(value:string);
    function FGetInstructions:string;
    procedure FSetInstructions(value:string);
    function FGetCName:string;
    procedure FSetCName(value:string);
    function FGetEmail:string;
    procedure FSetEmail(value:string);
    function FGetRemoveAccount:Boolean;
    procedure FSetRemoveAccount(value:Boolean);
    function FGetData:TData;
    procedure FSetData(value:TData);
  public
    constructor Create();overload;override;
    constructor Create(username,password:string);overload;
    property Username:string read FGetUsername write FSetUsername;
    property Password:string read FGetPassword write FSetPassword;
    property Instructions:string read FGetInstructions write FSetInstructions;
    property CName:string read FGetCName write FSetCName;
    property Email:string read FGetEmail write FSetEmail;
    property RemoveAccount:Boolean read FGetRemoveAccount write FSetRemoveAccount;
    property Data:TData read FGetData write FSetData;
    class function GetConstTagName():string;override;
  end;
  TRegisterIq=class(tiq)
  private
    _register:TRegister;
  public
    constructor Create;override;
    constructor Create(tp:string);overload;
    constructor Create(tp:string;tojid:TJID);overload;
    constructor Create(tp:string;tojid,fromjid:TJID);overload;
    property Query:TRegister read _register;
  end;
implementation

{ TRegister }

constructor TRegister.Create;
begin
  inherited;
  Name:='query';
  Namespace:=XMLNS_IQ_REGISTER;
end;

constructor TRegister.Create(username, password: string);
begin
  Self.Create;
  Self.username:=username;
  self.Password:=Password;
end;

function TRegister.FGetCName: string;
begin
  Result:=GetTag('name');
end;

function TRegister.FGetData: TData;
begin
  Result:=TData(GetFirstTag(TData.TagName));
end;

function TRegister.FGetEmail: string;
begin
  Result:=GetTag('email');
end;

function TRegister.FGetInstructions: string;
begin
  Result:=GetTag('instructions');
end;

function TRegister.FGetPassword: string;
begin
  Result:=GetTag('password');
end;

function TRegister.FGetRemoveAccount: Boolean;
begin
  result:=HasTag('remove');
end;

function TRegister.FGetUsername: string;
begin
  Result:=GetTag('username');
end;

procedure TRegister.FSetCName(value: string);
begin
  SetTag('name',value);
end;

procedure TRegister.FSetData(value: TData);
begin
  if HasTag(TData.TagName) then
    RemoveTag(tdata.TagName);
  if value<>nil then
    AddTag(value);
end;

procedure TRegister.FSetEmail(value: string);
begin
  SetTag('email',value);
end;

procedure TRegister.FSetInstructions(value: string);
begin
  SetTag('instructions',value);
end;

procedure TRegister.FSetPassword(value: string);
begin
  SetTag('password',value);
end;

procedure TRegister.FSetRemoveAccount(value: Boolean);
begin
  if value then
    AddTag('remove')
  else
    RemoveTag('remove');
end;

procedure TRegister.FSetUsername(value: string);
begin
  SetTag('username',value);
end;

class function TRegister.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_IQ_REGISTER;
end;

{ TRegisterIq }

constructor TRegisterIq.Create(tp: string);
begin
  IqType:=tp;
end;

constructor TRegisterIq.Create;
begin
  inherited;
  _register:=TRegister.Create;
  FSetQuery(_register);
  GenerateId;
end;

constructor TRegisterIq.Create(tp: string; tojid, fromjid: TJID);
begin
  Self.Create(tp,tojid);
  self.FromJid:=fromjid;
end;

constructor TRegisterIq.Create(tp: string; tojid: TJID);
begin
  Self.Create(tp);
  self.tojid:=tojid;
end;

end.
