unit Xmpp.sasl.Mechanisms;

interface
uses
  Element,XmppUri,Generics.Collections,XMPPConst,xmpp.sasl.Mechanism,System.Classes;
type
  TMechanisms=class(TElement)
  const
    TagName='mechanisms';
  public
    constructor Create;override;
    function GetMechanisms:TList;
    function SupportsMechanism(mechtype:TMechanismType):Boolean;
    class function GetConstTagName():string;override;
  end;

implementation

{ TMechanisms }

constructor TMechanisms.Create;
begin
  inherited Create;
  name:=TagName;
  Namespace:=XMLNS_SASL;
end;

class function TMechanisms.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_SASL;
end;

function TMechanisms.GetMechanisms: TList;
begin
  Result:=SelectElements('mechanism');
end;

function TMechanisms.SupportsMechanism(mechtype: TMechanismType): Boolean;
var
  el:TList;
  i:Integer;
begin
  result:=False;
  el:=GetMechanisms;
  for i:=0 to el.Count-1 do
    if TMechanism(el[i]).MechanismType=mechtype then
    begin
      Result:=true;
      exit;
    end;
end;

end.
