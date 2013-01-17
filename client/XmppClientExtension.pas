unit XmppClientExtension;

interface
uses
  XmppConnection,Element;
type

TXmppClientExtension=class
    protected
      client:TXmppConnection;
    public
      constructor Create(_client:TXmppConnection); virtual;
      destructor Destroy;override;
      function StreamParserElement(sender:TObject;e:TElement):Boolean;virtual;abstract;
  end;

implementation

{ TXmppClientExtension }

constructor TXmppClientExtension.Create(_client:TXmppConnection);
begin
  inherited Create;
  client:=_client;
end;

destructor TXmppClientExtension.Destroy;
begin

  inherited;
end;

end.
