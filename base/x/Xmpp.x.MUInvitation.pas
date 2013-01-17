unit Xmpp.x.MUInvitation;

interface
uses
  Xmpp.Stanza,XmppUri;
type
  TInvitation=class(TStanza)
  private
    function FGetReason:string;
    procedure FSetReason(value:string);
  public
    constructor Create();override;
    property Reason:string read FGetReason write FSetReason;
  end;

implementation

{ TInvitation }

constructor TInvitation.Create();
begin
  inherited Create();
  Namespace:=XMLNS_MUC_USER;
end;

function TInvitation.FGetReason: string;
begin
  Result:=GetTag('reason');
end;

procedure TInvitation.FSetReason(value: string);
begin
  settag('reason',value);
end;

end.
