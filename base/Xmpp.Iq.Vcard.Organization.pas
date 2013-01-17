unit Xmpp.Iq.Vcard.Organization;

interface
uses
  Element,XmppUri;
type
  TOrganization=class(TElement)
const
  TagName='ORG';
  private
    function FGetOrgName:string;
    procedure FSetOrgName(value:string);
    function FGetOrgUnit:string;
    procedure FSetOrgUnit(value:string);
  public
    constructor Create();override;
    constructor CreateOrganization(name,un:string);
    property OrgName:string read FGetOrgName write FSetOrgName;
    property OrgUnit:string read FGetOrgUnit write FSetOrgUnit;
    class function GetConstTagName():string;override;
  end;
implementation

{ TOrganization }

constructor TOrganization.Create();
begin
  inherited Create();
  name:='ORG';
  Namespace:=XMLNS_VCARD;
end;

constructor TOrganization.CreateOrganization(name, un: string);
begin
  self.Create();
  orgname:=name;
  orgunit:=un;
end;

function TOrganization.FGetOrgName: string;
begin
  Result:=GetTag('ORGNAME');

end;

function TOrganization.FGetOrgUnit: string;
begin
  Result:=GetTag('ORGUNIT');
end;

procedure TOrganization.FSetOrgName(value: string);
begin
  settag('ORGNAME',value);
end;

procedure TOrganization.FSetOrgUnit(value: string);
begin
  settag('ORGUNIT',value);
end;

class function TOrganization.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_VCARD;
end;

end.
