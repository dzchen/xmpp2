unit Xmpp.Item;

interface
uses
  Element,Jid,xmltag,classes;
type
  TItem=class(TElement)
  const
  TagName='item';
  private
    function fgetjid: TJID;
    procedure fsetjid(value:TJID);
    function fgetitemname:string;
    procedure fsetitemname(value:string);
  published
  public
    constructor Create();override;
    property Jid:TJID read fgetjid write fsetjid;
    property ItemName:string read fgetitemname write fsetitemname;
    class function GetConstTagName():string;override;
  end;
  TRosterItem=class(TItem)
  public
    procedure GetGroups(var alist:TList);
    procedure AddGroup(groupname:string);
    function HasGroup(groupname:string):Boolean;
    procedure RemoveGroup(groupname:string);

  end;

implementation
uses
  xmpp.group;

{ TItem }
constructor TItem.Create();
begin
  inherited Create();
  name:='item';
end;

function TItem.fgetitemname: string;
begin
  Result:=GetAttribute('name');
end;

function TItem.fgetjid: TJID;
begin
  if(HasAttribute('jid')) then
    Result:=TJID.Create(GetAttribute('jid'))
  else
    Result:=nil;
end;

procedure TItem.fsetitemname(value: string);
begin
  SetAttribute('name',value);
end;

procedure TItem.fsetjid(value: TJID);
begin
  if(value<>nil)then
    SetAttribute('jid',value.ToString)
  else
    SetAttribute('jid','');
end;

class function TItem.GetConstTagName: string;
begin
  Result:=TagName+'-';
end;

{ TRosterBaseItem }

procedure TRosterItem.AddGroup(groupname: string);
var
  g:TGroup;
begin
  g:=TGroup.Create(groupname);
  AddTag(g);
end;

procedure TRosterItem.GetGroups(var alist: TList);
begin
  alist:=SelectElements('group');
end;

function TRosterItem.HasGroup(groupname: string): Boolean;
var
  alist:TList;
  i:Integer;
begin
  alist:=TList.Create;
  GetGroups(alist);
  for i := 1 to alist.Count do
  begin

    if(TGroup(alist[i]).ItemName=groupname) then
    begin
      Result:=true;
      exit;
    end;
  end;
  Result:=False;
end;

procedure TRosterItem.RemoveGroup(groupname: string);
var
  alist:TList;
  i:Integer;
begin
  alist:=TList.Create;
  GetGroups(alist);
  for i := 1 to alist.Count do
  begin
    if(TGroup(alist[i]).ItemName=groupname) then
    begin
      RemoveTag(alist[i]);
      exit;
    end;
  end;
end;

end.

