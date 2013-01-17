unit Xmpp.Iq.DiscoItems;

interface
uses
  XmppUri,xmpp.client.IQ,Xmpp.iq.DiscoItem,Generics.Collections,Element,System.Classes;
type
  TDiscoItems=class(TIQ)
  const
    TagName='query';
    TagNameSpace=XMLNS_DISCO_ITEMS;
  private
    function FGetNode:string;
    procedure FSetNode(value:string);

  public
    constructor Create();override;
    property Node:string read FGetNode write FSetNode;
    function AddDiscoItem():TDiscoItem;overload;
    procedure AddDiscoItem(item:TDiscoItem);overload;
    function GetDiscoItems:TList;
    class function GetConstTagName():string;override;
  end;

implementation

{ TDiscoItems }

procedure TDiscoItems.AddDiscoItem(item: TDiscoItem);

begin
  AddTag(item);

end;

function TDiscoItems.AddDiscoItem: TDiscoItem;
var
  i:TDiscoItem;
begin
  i:=TDiscoItem.Create;
  AddTag(i);
  Result:=i;
end;

constructor TDiscoItems.Create;
begin
  inherited Create;
  Name:=TagName;
  Namespace:=TagNameSpace;
end;

function TDiscoItems.FGetNode: string;
begin
  result:=GetAttribute('node');
end;

procedure TDiscoItems.FSetNode(value: string);
begin
  SetAttribute('node',value);
end;

class function TDiscoItems.GetConstTagName: string;
begin
Result:=TagName+'-'+TagNameSpace;
end;

function TDiscoItems.GetDiscoItems: TList;
begin
  Result:=SelectElements(TDiscoItem.TagName);
end;

end.
