unit Xmpp.x.MUDecline;

interface
uses
  Xmpp.x.MUInvitation,jid;
type
  TDecline=class(TInvitation)
  const
  TagName='decline';
  public
    constructor Create();overload;override;
    constructor Create(reason:string);overload;
    constructor Create(tojid:TJID);overload;
    constructor Create(tojid:TJID;reason:string);overload;
    class function GetConstTagName():string;override;
  end;

implementation

{ TDecline }

constructor TDecline.Create(reason: string);
begin
  Self.Create();
  self.Reason:=reason;
end;

constructor TDecline.Create();
begin
  inherited Create();
  Name:='decline';
end;

constructor TDecline.Create(tojid: TJID; reason: string);
begin
  Self.Create();
  self.Reason:=reason;
  self.tojid:=tojid;
end;

class function TDecline.GetConstTagName: string;
begin
Result:=TagName+'-';
end;

constructor TDecline.Create(tojid: TJID);
begin
  Self.Create();
  self.tojid:=tojid;
end;

end.
