unit xmpp.group;

interface
uses
  Xmpp.Item;
type
  TGroup=class(TItem)
  const
    TagName='group';
  private
    function fgetitemname:string;
    procedure fsetitemname(value:string);
  public
    constructor Create();overload;override;
    constructor Create(groupname:string);overload;
    property ItemName read FGetItemName write FSetItemName;
    class function GetConstTagName():string;override;
  end;

implementation

{ TGroup }

constructor TGroup.Create();
begin
  inherited Create();
  Name:=TagName;
end;

constructor TGroup.Create(groupname: string);
begin
  self.Create();
  ItemName:=groupname;
end;

function TGroup.fgetitemname: string;
begin
  Result:=data;
end;

procedure TGroup.fsetitemname(value: string);
begin
  self.value:=value;
end;

class function TGroup.GetConstTagName: string;
begin
  Result:=TagName+'-';
end;

end.
