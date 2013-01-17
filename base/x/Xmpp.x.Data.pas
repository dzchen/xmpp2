unit Xmpp.x.Data;

interface
uses
  Xmpp.x.FieldContainer,XmppUri,XMPPConst,Xmpp.x.data.item,Xmpp.x.data.Reported
  ,Generics.Collections,Element,System.Classes;
type
  TData=class(Tfieldcontainer)
  const
  TagName='x';
  private
    function FGetTitle:string;
    procedure FSetTitle(value:string);
    function FGetInstructions:string;
    procedure FSetInstructions(value:string);
    function FGetDataType:string;
    procedure FSetDataType(value:string);
    function FGetReported:TReported;
    procedure FSetReported(value:TReported);
  public
    constructor Create();overload;override;
    constructor Create(datatype:string);overload;
    property Title:string read FGetTitle write FSetTitle;
    property Instructions:string read FGetInstructions write FSetInstructions;
    property DataType:string read FGetDataType write FSetDataType;
    property Reported:TReported read FGetReported write FSetReported;
    function AddItem:TItem;overload;
    procedure AddItem(item:TItem);overload;
    function GetItems():TList;
    class function GetConstTagName():string;override;
  end;

implementation

{ TData }

function TData.AddItem: TItem;
var
  i:TItem;
begin
  i:=Titem.Create;
  AddTag(i);
  Result:=i;
end;

procedure TData.AddItem(item: TItem);
begin
  AddTag(item);
end;

constructor TData.Create;
begin
  inherited Create;
  Name:='x';
  Namespace:=XMLNS_X_DATA;
end;

constructor TData.Create(datatype: string);
begin
  Self.Create;
  self.DataType:=datatype;
end;

function TData.FGetDataType: string;
begin
  Result:=GetAttribute('type');
end;

function TData.FGetInstructions: string;
begin
  Result:=GetTag('instructions');
end;

function TData.FGetReported: TReported;
begin
  Result:=TReported(GetFirstTag(TReported.TagName));
end;

function TData.FGetTitle: string;
begin
  Result:=GetTag('title');
end;

procedure TData.FSetDataType(value: string);
begin
  SetAttribute('type',value);
end;

procedure TData.FSetInstructions(value: string);
begin
  SetTag('instructions',value);
end;

procedure TData.FSetReported(value: TReported);
begin
  RemoveTag(TReported.TagName);
  AddTag(value);
end;

procedure TData.FSetTitle(value: string);
begin
  SetTag('title',value);
end;

class function TData.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_X_DATA;
end;

function TData.GetItems():TList;
begin
  Result:=SelectElements(TItem.TagName);
end;

end.
