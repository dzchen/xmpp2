unit Xmpp.shim.Header;

interface
uses
  Element,XmppUri;
type
  THeader=class(TElement)
  const
  TagName='header';
  private
    function FGetHeadName:string;
    procedure FSetHeadName(value:string);
  public
    constructor Create();override;
    constructor Create(nm,val:string);overload;
    property HeadName:string read FGetHeadName write FSetHeadName;
    class function GetConstTagName():string;override;
  end;

implementation

{ THeader }

constructor THeader.Create();
begin
  inherited Create();
  name:='header';
  Namespace:=XMLNS_SHIM;
end;

constructor THeader.Create(nm, val: string);
begin
  self.Create();
  HeadName:=nm;
  self.value:=val;
end;

function THeader.FGetHeadName: string;
begin
  Result:=GetAttribute('name');
end;

procedure THeader.FSetHeadName(value: string);
begin
  SetAttribute('name',value);
end;

class function THeader.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_SHIM;
end;

end.
