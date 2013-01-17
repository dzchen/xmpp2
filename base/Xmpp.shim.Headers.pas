unit Xmpp.shim.Headers;

interface
uses
  Element,XmppUri,Xmpp.shim.Header,SysUtils,Classes;
type
  THeaders=class(TElement)
  const
    TagName='headers';
  public
    constructor Create();override;
    function AddHeader:THeader;overload;
    function AddHeader(header:THeader):THeader;overload;
    function AddHeader(nm,val:string):THeader;overload;
    procedure SetHeaders(nm,val:string);
    function GetHeader(nm:string):THeader;
    procedure GetHeaders(al:TList);
    class function GetConstTagName():string;override;
  end;

implementation

{ THeaders }

function THeaders.AddHeader(nm, val: string): THeader;
var
  h:THeader;
begin
  h:=THeader.Create(nm,val);
  AddTag(h);
  Result:=h;
end;

function THeaders.AddHeader(header: THeader): THeader;
begin
  AddTag(header);
  Result:=header;
end;

function THeaders.AddHeader: THeader;
var
  h:THeader;
begin
  h:=THeader.Create();
  AddTag(h);
  Result:=h;
end;

constructor THeaders.Create();
begin
  inherited Create();
  name:='headers';
  Namespace:=XMLNS_SHIM;
end;

class function THeaders.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_SHIM;
end;

function THeaders.GetHeader(nm: string): THeader;
begin
  Result:=THeader(GetTag('header','name',nm));
end;

procedure THeaders.GetHeaders(al:TList);
begin
  al:=SelectElements('header');
end;

procedure THeaders.SetHeaders(nm, val: string);
var
  th:THeader;
begin
  th:=GetHeader(nm);
  if th<>nil then
    th.value:=val
  else
    AddHeader(nm,val);
end;

end.
