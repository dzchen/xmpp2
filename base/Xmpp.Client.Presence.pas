unit Xmpp.Client.Presence;

interface
uses
  xmpp.Stanza,XmppUri,xmpp.client.Error,xmpp.x.muc.User,xmpp.x.Delay,xmpp.extentions.Nickname,xmpp.extentions.Primary,SysUtils;
type
  TPresence=class(TStanza)
  const
  TagName='presence';
  private
    function FGetStatus:string;
    procedure FSetStatus(value:string);
    function FGetPresenceType:string;
    procedure FSetPresenceType(value:string);
    function FGetError:TError;
    procedure FSetError(value:TError);
    function FGetShow:string;
    procedure FSetShow(value:string);
    function FGetPriority:Integer;
    procedure FSetPriority(value:Integer);
    function FGetDelay:TDelay;
    procedure FSetDelay(value:TDelay);
    function FGetIsPrimary:Boolean;
    procedure FSetIsPrimary(value:Boolean);
    function FGetMucUser:TMUUser;
    procedure FSetMucUser(value:TMUUser);
    function FGetNickname:TNickname;
    procedure FSetNickname(value:TNickname);
  public
    constructor Create();override;
    constructor Create(show,status:string);overload;
    constructor Create(show,status:string;priority:integer);overload;
    property Status:string read FGetStatus write FSetStatus;
    property PresenceType:string read FGetPresenceType write FSetPresenceType;
    property Error:TError read FGetError write FSetError;
    property Show:string read FGetShow write FSetShow;
    property Priority:Integer read FGetPriority write FSetPriority;
    property XDelay:TDelay read FGetDelay write FSetDelay;
    property IsPrimary:Boolean read FGetIsPrimary write FSetIsPrimary;
    property MucUser:TMUUser read FGetMucUser write FSetMucUser;
    property Nickname:TNickname read FGetNickname write FSetNickname;
    class function GetConstTagName():string;override;
  end;

implementation

{ TPresence }

constructor TPresence.Create( show, status: string;
  priority: integer);
begin
   self.Create();
   self.Show:=show;
   self.Status:=status;
   self.Priority:=priority;
end;

constructor TPresence.Create(show, status: string);
begin
  self.Create();
  self.Show:=show;
  self.Status:=status;
end;

constructor TPresence.Create();
begin
  inherited Create();
  Name:=TagName;
  Namespace:=XMLNS_CLIENT;
end;

function TPresence.FGetDelay: TDelay;
begin
  Result:=TDelay(getfirsttag(TDelay.TagName));
end;

function TPresence.FGetError: TError;
begin
  result:=TError(getfirsttag(TError.TagName));
end;

function TPresence.FGetIsPrimary: Boolean;
begin
  if tagexists(TPrimary.TagName) then
    Result:=true
  else
    Result:=false;

end;

function TPresence.FGetMucUser: TMUUser;
begin
  Result:=TMUUser(getfirsttag(TMUUser.TagName));
end;

function TPresence.FGetNickname: TNickname;
begin
  Result:=TNickname(getfirsttag(TNickname.TagName));
end;

function TPresence.FGetPresenceType: string;
begin
  Result:=GetAttribute('type');
end;

function TPresence.FGetPriority: Integer;
begin
  Result:=strtoint(Getbasictext('priority'));
end;

function TPresence.FGetShow: string;
begin
  Result:=Getbasictext('show');
end;

function TPresence.FGetStatus: string;
begin
  Result:=Getbasictext('status');
end;

procedure TPresence.FSetDelay(value: TDelay);
begin
  ReplaceNode(value);
end;

procedure TPresence.FSetError(value: TError);
begin
  ReplaceNode(value);
end;

procedure TPresence.FSetIsPrimary(value: Boolean);
begin
  if Value then
    addtag(TPrimary.Create())
  else
    RemoveTag('p');
end;

procedure TPresence.FSetMucUser(value: TMUUser);
begin
  ReplaceNode(value);
end;

procedure TPresence.FSetNickname(value: TNickname);
begin
  ReplaceNode(value);
end;

procedure TPresence.FSetPresenceType(value: string);
begin
  if value='available' then
    RemoveAttribute('type')
  else
    SetAttribute('type',value);
end;

procedure TPresence.FSetPriority(value: Integer);
begin
  addbasictag('priority',inttostr(value));
end;

procedure TPresence.FSetShow(value: string);
begin
  if value='NONE' then
    RemoveAttribute('show')
  else
    SetAttribute('show',value);
end;

procedure TPresence.FSetStatus(value: string);
begin
  addbasictag('status',value);
end;

class function TPresence.GetConstTagName: string;
begin
  Result:=TagName+'-';
end;

end.
