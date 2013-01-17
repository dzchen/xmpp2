unit Xmpp.extensions.html.Html;

interface
uses
  Element,XmppUri,xmpp.extensions.html.body;
type
  THtml=class(TElement)
  const
  TagName='html';
  private
    function FGetBody:TBody;
    procedure FSetBody(value:TBody);
  public
    constructor Create();override;
    property Body:TBody read FGetBody write FSetBody;
    class function GetConstTagName():string;override;
  end;

implementation

{ THtml }

constructor THtml.Create();
begin
  inherited Create();
  name:='html';
  Namespace:=XMLNS_XHTML_IM;
end;

function THtml.FGetBody: TBody;
begin
  Result:=TBody(GetFirstTag(TBody.Tagname));
end;

procedure THtml.FSetBody(value: TBody);
begin
  if HasTag(TBody.Tagname) then
    RemoveTag(TBody.Tagname);
  if value<>nil then
    AddTag(value);
end;

class function THtml.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_XHTML_IM;
end;

end.
