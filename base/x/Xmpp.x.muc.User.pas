unit Xmpp.x.muc.User;

interface
uses
  Element,XmppUri,Xmpp.x.MUItem,Xmpp.x.MUStatus,Xmpp.x.MUInvite,Xmpp.x.MUDecline;
type
  TMUUser=class(TElement)
  const
  TagName='x';
  private
    function FGetItem:TMUItem;
    procedure FSetItem(value:TMUItem);
    function FGetStatus:TMUStatus;
    procedure FSetStatus(value:TMUStatus);
    function FGetInvite:TInvite;
    procedure FSetInvite(value:TInvite);
    function FGetDecline:TDecline;
    procedure FSetDecline(value:TDecline);
    function FGetPassword:string;
    procedure FSetPassword(value:string);
  public
    constructor Create();override;
    property Item:TMUItem read FGetItem write FSetItem;
    property Status:TMUStatus read FGetStatus write FSetStatus;
    property Invite:TInvite read FGetInvite write FSetInvite;
    property Decline:TDecline read FGetDecline write FSetDecline;
    property Password:string read FGetPassword write FSetPassword;
  end;
implementation

{ TMUUser }

constructor TMUUser.Create();
begin
  inherited Create();
  Name:='x';
  Namespace:=XMLNS_MUC_USER;
end;

function TMUUser.FGetDecline: TDecline;
begin
  result:=TDecline(GetFirstTag('decline'));
end;

function TMUUser.FGetInvite: TInvite;
begin
  result:=TInvite(GetFirstTag('invite'));
end;

function TMUUser.FGetItem: TMUItem;
begin
  result:=TMUItem(GetFirstTag('item'));
end;

function TMUUser.FGetPassword: string;
begin
  Result:=GetTag('password');
end;

function TMUUser.FGetStatus: TMUStatus;
begin
  result:=TMUStatus(GetFirstTag('status'));
end;

procedure TMUUser.FSetDecline(value: TDecline);
begin
  ReplaceNode(value);
end;

procedure TMUUser.FSetInvite(value: TInvite);
begin
  ReplaceNode(value);
end;

procedure TMUUser.FSetItem(value: TMUItem);
begin
  ReplaceNode(value);
end;

procedure TMUUser.FSetPassword(value: string);
begin
  settag('password',value);
end;

procedure TMUUser.FSetStatus(value: TMUStatus);
begin
  ReplaceNode(value);
end;

end.
