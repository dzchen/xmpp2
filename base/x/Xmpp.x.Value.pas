unit Xmpp.x.Value;

interface
uses
  Element,XmppUri;
type
  TValue=class(TElement)
  const
  TagName='value';
  public
    constructor Create();override;

    constructor Create(val:string);overload;
    constructor Create(val:Boolean);overload;
    class function GetConstTagName():string;override;
  end;

implementation

{ TValue }



constructor TValue.Create;
begin
  inherited Create;
  Name:='value';
  Namespace:=XMLNS_X_DATA;
end;

constructor TValue.Create(val: Boolean);
begin
  self.Create;
  if val then
    value:='1'
  else
    value:='0';
end;

class function TValue.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_X_DATA;
end;

constructor TValue.Create(val: string);
begin
  self.Create;
  value:=val;
end;

end.
