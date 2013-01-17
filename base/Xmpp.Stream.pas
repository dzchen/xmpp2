unit Xmpp.Stream;

interface
uses
  xmpp.Stanza;
type
  TStream=class(TStanza)
  const
  TagName='stream';
  private
    procedure FSetStreamId(value:string);
    function FGetStreamId():string;
    procedure FSetVersion(value:string);
    function FGetVersion():string;
  public

    constructor Create();override;
    property StreamId:string read FGetStreamId write FSetStreamId;
    property Version:string read FGetVersion write FSetVersion;
  end;

implementation

{ TStream }

constructor TStream.Create();
begin
  inherited Create();
  name:=TagName;
end;

function TStream.FGetStreamId: string;
begin
  Result:=GetAttribute('id');
end;

function TStream.FGetVersion: string;
begin
  Result:=GetAttribute('version');
end;

procedure TStream.FSetStreamId(value: string);
begin
  SetAttribute('id',value);
end;

procedure TStream.FSetVersion(value: string);
begin
  SetAttribute('version',value);
end;
end.
