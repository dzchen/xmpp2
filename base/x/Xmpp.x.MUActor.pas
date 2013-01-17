unit Xmpp.x.MUActor;

interface
uses
  Element,XmppUri,Jid;
type
  TMUActor=class(TElement)
  const
  TagName='actor';
  private
    function FGetJID:TJID;
    procedure FSetJID(value:TJID);
  public
    constructor Create();override;
    property Jid:TJID read FGetJID write FSetJID;
    class function GetConstTagName():string;override;
  end;

implementation

{ TMUActor }

constructor TMUActor.Create();
begin
  inherited Create();
  Name:='actor';
  Namespace:=XMLNS_MUC_USER;
end;

function TMUActor.FGetJID: TJID;
begin
  Result:=TJID.Create(GetAttribute('jid'));
end;

procedure TMUActor.FSetJID(value: TJID);
begin
  SetAttribute('jid',value.ToString);
end;

class function TMUActor.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_MUC_USER;
end;

end.
