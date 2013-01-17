unit Xmpp.extensions.html.Body;

interface
uses
  Element,XmppUri,StrUtils;
type
  TBody=class(TElement)
  const
  TagName='body';
  private
    function FGetInnerHtml:string;
  public
    constructor Create();override;
    property InnerHtml:string read FGetInnerHtml;
    class function GetConstTagName():string;override;
  end;

implementation

{ TBody }

constructor TBody.Create();
begin
  inherited Create();
  name:='body';
  Namespace:=XMLNS_XHTML;
end;

function TBody.FGetInnerHtml: string;
var
  s1,s2:string;
  istart,iend:integer;
begin
  s1:=self.ToString;
  istart:=Pos('>',s1);
  s2:=ReverseString(s1);
  iend:=Pos('</'+Name+'>',s2);
  Result:=MidStr(s1,istart,Length(s1)-istart-iend);
end;

class function TBody.GetConstTagName: string;
begin
  Result:=TagName+'-'+XMLNS_XHTML;
end;

end.
