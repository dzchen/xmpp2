unit Xmpp.extentions.Nickname;

interface
uses
  Element,XmppUri;
type
  TNickname=class(TElement)
  const
  TagName='nick';
  public
    constructor Create();override;
    constructor Create(nick:string);overload;
    class function GetConstTagName():string;override;
  end;
implementation

{ TNickname }

constructor TNickname.Create();
begin
  inherited Create();
  Name:='nick';
  Namespace:=XMLNS_NICK;
end;

constructor TNickname.Create(nick: string);
begin
  Self.Create();
  self.value:=nick;
end;

class function TNickname.GetConstTagName: string;
begin
Result:=TagName+'-'+XMLNS_NICK;
end;

end.
