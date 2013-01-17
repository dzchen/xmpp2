unit Xmpp.x.MUItem;

interface
uses
  Element,Xmpp.x.MUActor,Xmpp.Item,XmppUri;
type
  TMUItem=class(TItem)
  private
    function FGetRole:string;
    procedure FSetRole(value:string);
    function FGetAffiliation:string;
    procedure FSetAffiliation(value:string);
    function FGetNickname:string;
    procedure FSetNickname(value:string);
    function FGetReason:string;
    procedure FSetReason(value:string);
    function FGetActor:TMUActor;
    procedure FSetActor(value:TMUActor);

  public
    constructor Create();overload;override;
    constructor CreateAffiliation(affiliation:string);
    constructor CreateRole(role:string);
    constructor Create(affiliation,role:string);overload;
    constructor Create(affiliation,role,reason:string);overload;
    property Role:string read FGetRole write FSetRole;
    property Affiliation:string read FGetAffiliation write FSetAffiliation;
    property Nickname:string read FGetNickname write FSetNickname;
    property Reason:string read FGetReason write FSetReason;
    property Actor:TMUActor read FGetActor write FSetActor;
  end;

implementation

{ TMUItem }

constructor TMUItem.Create();
begin
  inherited Create();
  Name:='item';
  Namespace:=XMLNS_MUC_USER;
end;

constructor TMUItem.Create( affiliation, role: string);
begin
  Self.Create();
  self.Affiliation:=affiliation;
  self.Role:=role;
end;

constructor TMUItem.Create( affiliation, role,
  reason: string);
begin
  Self.Create();
  self.Affiliation:=affiliation;
  self.Role:=role;
  Self.Reason:=reason;
end;

constructor TMUItem.CreateAffiliation(affiliation: string);
begin
  Self.Create();
  self.Affiliation:=affiliation;
end;

constructor TMUItem.CreateRole( role: string);
begin
  Self.Create();
  self.Role:=role;
end;

function TMUItem.FGetActor: TMUActor;
begin
  Result:=TMUActor(GetFirstTag('actor'));
end;

function TMUItem.FGetAffiliation: string;
begin
  Result:=GetAttribute('affiliation');
end;

function TMUItem.FGetNickname: string;
begin
  Result:=GetAttribute('nick');
end;

function TMUItem.FGetReason: string;
begin
  Result:=GetTag('reason');
end;

function TMUItem.FGetRole: string;
begin
  Result:=GetAttribute('role');
end;

procedure TMUItem.FSetActor(value: TMUActor);
begin
  ReplaceNode(value);
end;

procedure TMUItem.FSetAffiliation(value: string);
begin
  SetAttribute('affiliation',value);
end;

procedure TMUItem.FSetNickname(value: string);
begin
  SetAttribute('nick',value);
end;

procedure TMUItem.FSetReason(value: string);
begin
  SetTag('reason',value);
end;

procedure TMUItem.FSetRole(value: string);
begin
  SetAttribute('role',value);
end;

end.
