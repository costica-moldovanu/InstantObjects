unit TestInstantString;

interface

uses fpcunit, InstantPersistence, InstantMock;

type

  // Test methods for class TInstantString
  TestTInstantString = class(TTestCase)
  private
    FAttrMetadata: TInstantAttributeMetadata;
    FConn: TInstantMockConnector;
    FInstantString: TInstantString;
    FOwner: TInstantObject;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAsBoolean;
    procedure TestAsCurrency;
    procedure TestAsDateTime;
    procedure TestAsFloat;
    procedure TestAsInteger;
    procedure TestAsObject;
    procedure TestAssign;
    procedure TestAsString;
    procedure TestAsVariant;
    procedure TestName;
    procedure TestOwner;
    procedure TestReset;
    procedure TestValue;
  end;

implementation

uses SysUtils, testregistry, InstantClasses;

procedure TestTInstantString.SetUp;
begin
  FConn := TInstantMockConnector.Create(nil);
  FConn.BrokerClass := TInstantMockBroker;
  FOwner := TInstantObject.Create(FConn);
  FAttrMetadata := TInstantAttributeMetadata.Create(nil);
  FAttrMetadata.AttributeClass := TInstantString;
  FAttrMetadata.Name := 'AttrMetadataName';
  FInstantString := TInstantString.Create(FOwner, FAttrMetadata);
  FInstantString.Value := 'StringValue';
end;

procedure TestTInstantString.TearDown;
begin
  FreeAndNil(FInstantString);
  FreeAndNil(FAttrMetadata);
  FreeAndNil(FOwner);
  FreeAndNil(FConn);
end;

procedure TestTInstantString.TestAsBoolean;
begin
  FInstantString.AsBoolean := True;
  AssertEquals('True', FInstantString.Value);
  AssertTrue(FInstantString.AsBoolean);

  FInstantString.AsBoolean := False;
  AssertEquals('False', FInstantString.Value);
  AssertFalse(FInstantString.AsBoolean);
end;

procedure TestTInstantString.TestAsCurrency;
var
  vCurr: Currency;
begin
  vCurr := 23.45;
  FInstantString.AsCurrency := vCurr;
  AssertEquals('23' + DecimalSeparator + '45', FInstantString.Value);
  AssertEquals(vCurr, FInstantString.AsCurrency);
end;

procedure TestTInstantString.TestAsDateTime;
begin
  FInstantString.AsDateTime := 12.45;
  AssertEquals(DateTimeToStr(12.45), FInstantString.Value);
  AssertEquals(12.45, FInstantString.AsDateTime);
end;

procedure TestTInstantString.TestAsFloat;
begin
  FInstantString.AsFloat := 89.45;
  AssertEquals('89' + DecimalSeparator + '45', FInstantString.Value);
  AssertEquals(89.45, FInstantString.AsFloat);
end;

procedure TestTInstantString.TestAsInteger;
begin
  FInstantString.AsInteger := 100;
  AssertEquals('100', FInstantString.Value);
  AssertEquals(100, FInstantString.AsInteger);
end;

procedure TestTInstantString.TestAsObject;
begin
  try
    FInstantString.AsObject := TInstantObject.Create(FConn);
    Fail('Exception was not thrown for Set AsObject!'); // should never get here
  except
    on E: EInstantAccessError do ; // do nothing as this is expected
    else
      raise;
  end;
  try
    FInstantString.AsObject;
    Fail('Exception was not thrown for Get AsObject!'); // should never get here
  except
    on E: EInstantAccessError do ; // do nothing as this is expected
    else
      raise;
  end;
end;

procedure TestTInstantString.TestAssign;
var
  vSource: TInstantString;
begin
  AssertEquals('StringValue', FInstantString.Value);

  vSource := TInstantString.Create;
  try
    VSource.Value := 'DifferentString';
    FInstantString.Assign(vSource);
    AssertEquals('DifferentString', FInstantString.Value);
  finally
    vSource.Free;
  end;
end;

procedure TestTInstantString.TestAsString;
begin
  FInstantString.AsString := 'DifferentString';
  AssertEquals('DifferentString', FInstantString.Value);
  AssertEquals('DifferentString', FInstantString.AsString);
end;

procedure TestTInstantString.TestAsVariant;
begin                                           
  FInstantString.AsVariant := 'DifferentString';
  AssertEquals('DifferentString', FInstantString.Value);
  AssertEquals('DifferentString', FInstantString.AsVariant);
end;

procedure TestTInstantString.TestName;
begin
  AssertEquals('AttrMetadataName', FInstantString.Name);
end;

procedure TestTInstantString.TestOwner;
begin
  AssertSame(FOwner, FInstantString.Owner);
end;

procedure TestTInstantString.TestReset;
begin
  AssertNotNull(FInstantString.Metadata);
  // Metadata.DefaultValue is '';
  FInstantString.Reset;
  AssertEquals('', FInstantString.Value);

  FInstantString.Metadata.DefaultValue := '1000';
  FInstantString.Reset;
  AssertEquals('1000', FInstantString.Value);

  FInstantString.Metadata := nil;
  AssertNull(FInstantString.Metadata);
  FInstantString.Reset;
  AssertEquals('', FInstantString.Value);
end;

procedure TestTInstantString.TestValue;
begin
  AssertEquals('StringValue', FInstantString.Value);
  FInstantString.Value := 'NewValue';
  AssertEquals('NewValue', FInstantString.Value);
end;

initialization
  // Register any test cases with the test runner
{$IFNDEF CURR_TESTS}
  RegisterTests([TestTInstantString]);
{$ENDIF}

end.
 