unit Xmpp.steam.Stream;

interface
uses
  xmpp.Stream,XmppUri;
type
  TStream=class(xmpp.Stream.TStream)
  public
    constructor Create;override;
  end;

implementation

{ TStream }

constructor TStream.Create;
begin
  inherited create;
  Namespace:=XMLNS_STREAM;
end;

end.
