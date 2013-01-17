unit Xmpp.Iq.DiscoInfo;

interface
uses
  Element,XmppUri,Xmpp.iq.DiscoIdentity,Xmpp.iq.DiscoFeature,Generics.Collections,System.Classes;
type
  TDiscoInfo=class(TElement)
  const
  TagName='query';
  private
    function FGetNode:string;
    procedure FSetNode(value:string);
  public
    constructor Create();overload;override;
    property Node:string read FGetNode write FSetNode;
    function AddIdentity():TDiscoIdentity;overload;
    procedure AddIdentity(id:TDiscoIdentity);overload;
    function AddFeature():TDiscoFeature;overload;
    procedure AddFeature(f:TDiscoFeature);overload;
    function GetIdentities():TList;
    function GetFeatures():TList;
    function HasFeature(v:string):Boolean;
    class function GetConstTagName():string;override;
  end;

implementation

{ TDiscoInfo }

procedure TDiscoInfo.AddFeature(f: TDiscoFeature);
begin
  AddTag(f);
end;

function TDiscoInfo.AddFeature: TDiscoFeature;
var
  f:TDiscoFeature;
begin
  f:=TDiscoFeature.Create;
  AddTag(f);
  Result:=f;
end;

procedure TDiscoInfo.AddIdentity(id: TDiscoIdentity);
begin
  AddTag(id);
end;

function TDiscoInfo.AddIdentity: TDiscoIdentity;
var
  f:TDiscoIdentity;
begin
  f:=TDiscoIdentity.Create;
  AddTag(f);
  Result:=f;
end;

constructor TDiscoInfo.Create;
begin
  inherited create;
  Name:='query';
  Namespace:=XMLNS_DISCO_INFO;
end;

function TDiscoInfo.FGetNode: string;
begin
  Result:=GetAttribute('node');
end;

procedure TDiscoInfo.FSetNode(value: string);
begin
  SetAttribute('node',value);
end;

class function TDiscoInfo.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_DISCO_INFO;
end;

function TDiscoInfo.GetFeatures: TList;
begin
  Result:=SelectElements(TDiscoFeature.TagName);
end;

function TDiscoInfo.GetIdentities: TList;
begin
  Result:=SelectElements(Xmpp.iq.DiscoIdentity.TDiscoIdentity.TagName);
end;

function TDiscoInfo.HasFeature(v: string): Boolean;
var
  el:Tlist;
  i:integer;
begin
  el:=tlist.Create;
  el:=GetFeatures;
  for i:=0 to el.Count-1 do
    if TDiscoFeature(el[i]).DiscoVar=v then
    begin
      Result:=true;
      exit;
    end;
  Result:=false;
end;

end.
