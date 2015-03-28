unit ACBrUtilTest;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  {$ifdef FPC}
  fpcunit, testutils, testregistry
  {$else}
  TestFramework
  {$endif};

type

  { ParseTextTest }

  ParseTextTest = class(TTestCase)
  private
  published
    procedure ParseDecode;
    procedure ParseEncode;
    procedure VerificarConversaoTextoLongo;
  end;

  { LerTagXMLTest }

  LerTagXMLTest = class(TTestCase)
  published
    procedure Simples;
    procedure SemIgnorarCase;
    procedure ComVariasTags;
  end;

  { DecodeToStringTest }

  DecodeToStringTest = class(TTestCase)
  published
    procedure TesteUTF8;
    procedure TesteAnsi;
  end;

  { SepararDadosTest }

  SepararDadosTest = class(TTestCase)
  published
    procedure Simples;
    procedure TextoLongo;
    procedure MostrarChave;
    procedure ComVariasChaves;
    procedure SemFecharChave;
    procedure SemAbrirChave;
  end;

  { QuebrarLinhaTest }

  QuebrarLinhaTest = class(TTestCase)
  published
    procedure TresCampos;
    procedure PipeDelimiter;
  end;

  { ACBrStrTest }

  ACBrStrTest = class(TTestCase)
  published
    procedure TesteUTF8;
    procedure TesteAnsi;
  end;

  { ACBrStrToAnsiTest }

  ACBrStrToAnsiTest = class(TTestCase)
  published
    procedure TesteUTF8;
    procedure TesteReverso;
  end;

  { TruncFixTest }

  TruncFixTest = class(TTestCase)
  published
    procedure AsExpression;
    procedure AsDouble;
    procedure AsExtended;
    procedure AsCurrency;
  end;

  { RoundABNTTest }

  RoundABNTTest = class(TTestCase)
  published
    procedure AsIntegerImpar;
    procedure AsIntegerPar;
    procedure TresParaDuasCasasDecimais;
    procedure QuatroParaDuasCasasDecimais;
  end;

  { padRightTest }

  padRightTest = class(TTestCase)
  published
    procedure CompletarString;
    procedure ManterString;
    procedure TruncarString;
  end;

  { padLeftTest }

  padLeftTest = class(TTestCase)
  published
   procedure CompletarString;
   procedure ManterString;
   procedure TruncarString;
  end;

  { padCenterTest }

  padCenterTest = class(TTestCase)
  published
   procedure PreencherString;
   procedure TruncarString;
  end;

  { padSpaceTest }

  padSpaceTest = class(TTestCase)
  published
   procedure CompletarString;
   procedure TruncarString;
   procedure SubstituirSeparadorPorEspacos;
   procedure SubstituirSeparadorPorCaracter;
  end;

  { RemoverEspacosDuplosTest }

  RemoverEspacosDuplosTest = class(TTestCase)
  published
   procedure RemoverApenasEspacosDuplos;
   procedure RemoverMaisQueDoisEspacos;
  end;

  { RemoveStringTest }

  RemoveStringTest = class(TTestCase)
  published
   procedure Remover;
  end;

  { RemoveStringsTest }

  RemoveStringsTest = class(TTestCase)
  private
    StringsToRemove: array [1..5] of AnsiString;
  protected
    procedure SetUp; override;
  published
   procedure TextoSimples;
   procedure TextoLongo;
  end;

  { StripHTMLTest }

  StripHTMLTest = class(TTestCase)
  published
   procedure TesteSimples;
   procedure TesteCompleto;
  end;

  { RemoveEmptyLinesTest }

  RemoveEmptyLinesTest = class(TTestCase)
  private
    SL: TStringList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
   procedure VerificarLinhas;
   procedure VerificarConteudo;
  end;

  { RandomNameTest }

  RandomNameTest = class(TTestCase)
  published
   procedure TamanhoDois;
   procedure TamanhoQuatro;
   procedure TamanhoOito;
  end;

  { CompareVersionsTest }

  CompareVersionsTest = class(TTestCase)
  published
   procedure VersaoIgual;
   procedure VersaoMaior;
   procedure VersaoMenor;
   procedure TrocarDelimitador;
   procedure NomeclaturaDiferente;
  end;

  { TestBitTest }

  TestBitTest = class(TTestCase)
  published
    procedure TestarTodosBits;
  end;

  { IntToBinTest }

  IntToBinTest = class(TTestCase)
  published
    procedure TestarTodosBits;
  end;

  { BinToIntTest }

  BinToIntTest = class(TTestCase)
  published
    procedure TestarTodosBits;
  end;

  { BcdToAscTest }

  BcdToAscTest = class(TTestCase)
  published
    procedure Normal;
    procedure ComZerosAEsquerda;
  end;

  { AscToBcdTest }

  AscToBcdTest = class(TTestCase)
  published
    procedure TamanhoTres;
    procedure TruncandoComTamanhoDois;
    procedure AumentandoComtamanhoQuatro;
  end;

  { IntToLEStrTest }

  IntToLEStrTest = class(TTestCase)
  published
    procedure TamanhoUm;
    procedure TamanhoDois;
    procedure TamanhoQuatro;
  end;

  { LEStrToIntTest }

  LEStrToIntTest = class(TTestCase)
  published
    procedure TamanhoUm;
    procedure TamanhoDois;
    procedure TamanhoQuatro;
  end;

  { HexToAsciiTest }

  HexToAsciiTest = class(TTestCase)
  published
    procedure Simples;
    procedure Comlexo;
  end;

  { AsciiToHexTest }

  AsciiToHexTest = class(TTestCase)
  published
    procedure Simples;
    procedure Comlexo;
  end;

  { BinaryStringToStringTest }

  BinaryStringToStringTest = class(TTestCase)
  published
    procedure Simples;
    procedure Reverso;
  end;

  { StringToBinaryStringTest }

  StringToBinaryStringTest = class(TTestCase)
  published
    procedure Simples;
    procedure Reverso;
  end;

  { IfEmptyThenTest }

  IfEmptyThenTest = class(TTestCase)
  published
   procedure RetornarValorNormal;
   procedure SeVazioRetornaValorPadrao;
   procedure RealizarDoTrim;
   procedure NaoRealizarDoTrim;
  end;

  { PosAtTest }

  PosAtTest = class(TTestCase)
  private
    AStr: String;
  protected
    procedure SetUp; override;
  published
   procedure AchaPrimeiraOcorrencia;
   procedure AchaSegundaOcorrencia;
   procedure AchaTerceiraOcorrencia;
   procedure NaoAchaOcorrencia;
  end;

  { PosLastTest }

  PosLastTest = class(TTestCase)
  private
    AStr: String;
  protected
    procedure SetUp; override;
  published
   procedure AchaOcorrencia;
   procedure NaoAchaOcorrencia;
  end;

  { PosLastTest }

  { CountStrTest }

  CountStrTest = class(TTestCase)
  private
    AStr: String;
  protected
    procedure SetUp; override;
  published
   procedure AchaOcorrencia;
   procedure NaoAchaOcorrencia;
  end;

  { Poem_ZerosTest }

  Poem_ZerosTest = class(TTestCase)
  published
    procedure ParamString;
    procedure Truncando;
    procedure ParamInt64;
  end;

  { IntToStrZeroTest }

  IntToStrZeroTest = class(TTestCase)
  published
   procedure AdicionarZerosAoNumero;
   procedure TamanhoMenorQueLimite;
  end;

  { FloatToIntStrTest }

  FloatToIntStrTest = class(TTestCase)
  published
   procedure Normal;
   procedure ValorDecimaisDefault;
   procedure MudandoPadraoDeDecimais;
   procedure SemDecimais;
   procedure ValorComMaisDecimais;
  end;

  { FloatToStringTest }

  FloatToStringTest = class(TTestCase)
  published
   procedure Normal;
   procedure ComDecimaisZerados;
   procedure MudandoPontoDecimal;
   procedure ComFormatacao;
   procedure RemovendoSerparadorDeMilhar;
  end;

  { FormatFloatBrTest }

  FormatFloatBrTest = class(TTestCase)
  published
   procedure Normal;
   procedure ComDecimaisZerados;
   procedure ComFormatacao;
   procedure ComSerparadorDeMilhar;
  end;

  { FloatMaskTest }

  FloatMaskTest = class(TTestCase)
  published
   procedure Inteiro;
   procedure DuasCasas;
   procedure QuatroCasas;
  end;

  { StringToFloatTest }

  StringToFloatTest = class(TTestCase)
  published
   procedure ComVirgula;
   procedure ComPonto;
   procedure ApenasInteiro;
  end;

  { StringToFloatDefTest }

  StringToFloatDefTest = class(TTestCase)
  published
   procedure ComVirgula;
   procedure ComPonto;
   procedure ApenasInteiro;
   procedure ValorDefault;
  end;

  { StringToDateTimeTest }

  StringToDateTimeTest = class(TTestCase)
  published
   procedure Data;
   procedure Hora;
   procedure DataEHora;
  end;

  { StringToDateTimeDefTest }

  StringToDateTimeDefTest = class(TTestCase)
  published
   procedure Data;
   procedure Hora;
   procedure DataEHora;
   procedure ValorDefault;
  end;

  { StoDTest }

  StoDTest = class(TTestCase)
  published
   procedure Normal;
   procedure DataSemHora;
   procedure DataInvalida;
  end;

  { DtoSTest }

  DtoSTest = class(TTestCase)
  published
   procedure Data;
  end;

  { DTtoSTest }

  DTtoSTest = class(TTestCase)
  published
   procedure DataEHora;
   procedure DataSemHora;
  end;

  { StrIsAlphaTest }

  StrIsAlphaTest = class(TTestCase)
  published
   procedure Texto;
   procedure TextoComNumeros;
   procedure TextoComCaractersEspeciais;
   procedure TextoComCaractersAcentuados;
  end;

  { StrIsAlphaNumTest }

  StrIsAlphaNumTest = class(TTestCase)
  published
    procedure Texto;
    procedure TextoComNumeros;
    procedure TextoComCaractersEspeciais;
    procedure TextoComCaractersAcentuados;
  end;

  { StrIsNumberTest }

  StrIsNumberTest = class(TTestCase)
  published
    procedure Texto;
    procedure Numeros;
    procedure TextoComNumeros;
    procedure TextoComSeparadores;
    procedure TextoComCaractersEspeciais;
  end;

  { CharIsAlphaTest }

  CharIsAlphaTest = class(TTestCase)
  published
    procedure Caracter;
    procedure Numero;
    procedure CaracterEspecial;
  end;

  { CharIsAlphaNumTest }

  CharIsAlphaNumTest = class(TTestCase)
  published
    procedure Caracter;
    procedure Numero;
    procedure CaracterEspecial;
  end;

  { CharIsNumTest }

  CharIsNumTest = class(TTestCase)
  published
    procedure Caracter;
    procedure Numero;
    procedure CaracterEspecial;
  end;

  { OnlyNumberTest }

  OnlyNumberTest = class(TTestCase)
  private
  published
    procedure Texto;
    procedure Numeros;
    procedure TextoComNumeros;
    procedure TextoComSeparadores;
    procedure TextoComCaractersEspeciais;
  end;

  { OnlyAlphaTest }

  OnlyAlphaTest = class(TTestCase)
  published
    procedure Texto;
    procedure Numeros;
    procedure TextoComNumeros;
    procedure TextoComCaractersEspeciais;
  end;

  { OnlyAlphaNumTest }

  OnlyAlphaNumTest = class(TTestCase)
  published
    procedure Texto;
    procedure Numeros;
    procedure TextoComNumeros;
    procedure TextoComCaractersEspeciais;
  end;

  { StrIsIPTest }

  StrIsIPTest = class(TTestCase)
  published
    procedure Normal;
    procedure SemPonto;
    procedure ComNome;
    procedure Errados;
  end;

  { TiraAcentosTest }

  TiraAcentosTest = class(TTestCase)
  published
    procedure Normal;
  end;

  { TiraAcentoTest }

  TiraAcentoTest = class(TTestCase)
  published
    procedure Normal;
  end;

implementation

uses
  Math, dateutils,
  ACBrUtil;

{ FloatMaskTest }

procedure FloatMaskTest.Inteiro;
begin
  CheckEquals('0',FloatMask(0));
end;

procedure FloatMaskTest.DuasCasas;
begin
  CheckEquals('0.00',FloatMask(2));
end;

procedure FloatMaskTest.QuatroCasas;
begin
  CheckEquals('0.0000',FloatMask(4));
end;

{ FormatFloatBrTest }

procedure FormatFloatBrTest.Normal;
begin
  CheckEquals('115,89', FormatFloatBr(115.89));
end;

procedure FormatFloatBrTest.ComDecimaisZerados;
begin
  CheckEquals('115,00', FormatFloatBr(115.00));
end;

procedure FormatFloatBrTest.ComFormatacao;
begin
  CheckEquals('115,8900', FormatFloatBr(115.89, '0.0000'));
end;

procedure FormatFloatBrTest.ComSerparadorDeMilhar;
begin
  CheckEquals('123.456,789', FormatFloatBr(123456.789, '###,000.000'));
end;

{ CountStrTest }

procedure CountStrTest.SetUp;
begin
  // 0....+....1....+....2....+....3....+....
  AStr := 'Projeto ACBr, Teste Unit�rio ACBr. ACBr' ;
end;

procedure CountStrTest.AchaOcorrencia;
begin
  CheckEquals(3, CountStr(AStr, 'e'));
  CheckEquals(3, CountStr(AStr, 'ACBr'));
  CheckEquals(1, CountStr(AStr, '.'));
end;

procedure CountStrTest.NaoAchaOcorrencia;
begin
  CheckEquals(0, CountStr('z', AStr));
  CheckEquals(0, CountStr('ACBR', AStr));
end;

{ PosLastTest }

procedure PosLastTest.SetUp;
begin
  // 0....+....1....+....2....+....3....+....
  AStr := 'Projeto ACBr, Teste Unit�rio ACBr. ACBr' ;
end;

procedure PosLastTest.AchaOcorrencia;
begin
  CheckEquals(19, PosLast('e', AStr));
  CheckEquals(36, PosLast('ACBr', AStr));
  CheckEquals(1, PosLast('Projeto', AStr));
end;

procedure PosLastTest.NaoAchaOcorrencia;
begin
  CheckEquals(0, PosLast('z', AStr));
  CheckEquals(0, PosLast('ACBR', AStr));
end;

{ PosAtTest }

procedure PosAtTest.SetUp;
begin
       // 0....+....1....+....2....+....3....+....
  AStr := 'Projeto ACBr, Teste Unit�rio ACBr. ACBr' ;
end;

procedure PosAtTest.AchaPrimeiraOcorrencia;
begin
  CheckEquals(5, PosAt('e', AStr));
  CheckEquals(9, PosAt('ACBr', AStr));
end;

procedure PosAtTest.AchaSegundaOcorrencia;
begin
  CheckEquals(16, PosAt('e', AStr, 2));
  CheckEquals(30, PosAt('ACBr', AStr, 2));
end;

procedure PosAtTest.AchaTerceiraOcorrencia;
begin
  CheckEquals(19, PosAt('e', AStr, 3));
  CheckEquals(36, PosAt('ACBr', AStr, 3));
end;

procedure PosAtTest.NaoAchaOcorrencia;
begin
  CheckEquals(0, PosAt('z', AStr));
  CheckEquals(0, PosAt('ACBR', AStr));
  CheckEquals(0, PosAt('e', AStr, 4));
  CheckEquals(0, PosAt('ACBr', AStr, 4));
end;

{ RandomNameTest }

procedure RandomNameTest.TamanhoDois;
var
  AName: String;
begin
  AName := RandomName(2);
  CheckEquals(2, Length(AName));
  CheckTrue( StrIsAlpha(AName) );
end;

procedure RandomNameTest.TamanhoQuatro;
var
  AName: String;
begin
  AName := RandomName(4);
  CheckEquals(4, Length(AName));
  CheckTrue( StrIsAlpha(AName) );
end;

procedure RandomNameTest.TamanhoOito;
var
  AName: String;
begin
  AName := RandomName(8);
  CheckEquals(8, Length(AName));
  CheckTrue( StrIsAlpha(AName) );
end;

{ RemoveEmptyLinesTest }

procedure RemoveEmptyLinesTest.SetUp;
begin
  SL := TStringList.Create;
  SL.Add('');
  SL.Add('');
  SL.Add('Linha1');
  SL.Add('');
  SL.Add('Linha2');
  SL.Add('');
  SL.Add('');
  SL.Add('Linha3');
  SL.Add('');
  SL.Add('');

  RemoveEmptyLines( SL );
end;

procedure RemoveEmptyLinesTest.TearDown;
begin
  SL.Free;
end;

procedure RemoveEmptyLinesTest.VerificarLinhas;
begin
  CheckEquals( 3, SL.Count);
end;

procedure RemoveEmptyLinesTest.VerificarConteudo;
var
  Texto: String;
begin
  Texto := SL.Text;
  CheckEquals('Linha1'+sLineBreak+'Linha2'+sLineBreak+'Linha3'+sLineBreak, Texto );
 end;

{ StringToBinaryStringTest }

procedure StringToBinaryStringTest.Simples;
begin
  CheckEquals(chr(1)+'ABC'+chr(255)+'123', StringToBinaryString('\x01ABC\xFF123'));
end;

procedure StringToBinaryStringTest.Reverso;
Var
  AllChars: AnsiString;
  I: Integer;
  Resp: String;
begin
  AllChars := '';
  Resp := '';
  For I := 0 to 31 do
  begin
    AllChars := AllChars + chr(I) ;
    Resp := Resp + '\x'+Trim(IntToHex(I,2)) ;
  end;

  CheckTrue(AllChars = StringToBinaryString(Resp) ) ;
end;

{ BinaryStringToStringTest }

procedure BinaryStringToStringTest.Simples;
begin
  CheckEquals('\x01ABC\xFF123', BinaryStringToString(chr(1)+'ABC'+chr(255)+'123'));
end;

procedure BinaryStringToStringTest.Reverso;
Var
  AllChars: AnsiString;
  I: Integer;
  Resp: String;
begin
  AllChars := '';
  Resp := '';
  For I := 0 to 31 do
  begin
    AllChars := AllChars + chr(I) ;
    Resp := Resp + '\x'+Trim(IntToHex(I,2)) ;
  end;

  CheckEquals(Resp, BinaryStringToString(AllChars) ) ;
end;

{ AsciiToHexTest }

procedure AsciiToHexTest.Simples;
begin
  CheckEquals('41424344', AsciiToHex('ABCD') );
end;

procedure AsciiToHexTest.Comlexo;
begin
  CheckEquals('312C4D6FFF', AsciiToHex('1,Mo'+chr(255)) );
end;

{ HexToAsciiTest }

procedure HexToAsciiTest.Simples;
begin
  CheckEquals('ABCD', HexToAscii('41424344') );
end;

procedure HexToAsciiTest.Comlexo;
begin
  CheckEquals('1,Mo'+chr(255), HexToAscii('312C4D6FFF') );
end;

{ LEStrToIntTest }

procedure LEStrToIntTest.TamanhoUm;
begin
  CheckEquals( 255, LEStrToInt(chr(255)) );
end;

procedure LEStrToIntTest.TamanhoDois;
begin
  CheckEquals( 106 , LEStrToInt(chr(106) + chr(00)) );
end;

procedure LEStrToIntTest.TamanhoQuatro;
var
  LEStr: AnsiString;
begin
  LEStr := IntToLEStr(1056,4);

  CheckEquals( 1056, LEStrToInt(LEStr) );
  CheckEquals( 1056, LEStrToInt(chr(32) + chr(04) + chr(00) + chr(00)) );
  CheckEquals( AsciiToHex(LEStr), AsciiToHex(chr(32) + chr(04) + chr(00) + chr(00)));
end;

{ IntToLEStrTest }

procedure IntToLEStrTest.TamanhoUm;
begin
  CheckEquals( chr(255), IntToLEStr(255,1) );
end;

procedure IntToLEStrTest.TamanhoDois;
begin
  CheckEquals( chr(106) + chr(00), IntToLEStr(106,2) );
end;

procedure IntToLEStrTest.TamanhoQuatro;
var
  LEStr: AnsiString;
begin
  LEStr := IntToLEStr(1056,4);
  // CheckEquals simples falharia pois a String inicia com '0'
  CheckTrue( LEStr = chr(32) + chr(04) + chr(00) + chr(00));
end;

{ AscToBcdTest }

procedure AscToBcdTest.TamanhoTres;
var
  BCD: String;
  A: String;
begin
  BCD := AscToBcd('123456',3);
  CheckEquals(chr(18) + chr(52) + chr(86), BCD );
  CheckEquals('123456',BcdToAsc(BCD));
end;

procedure AscToBcdTest.TruncandoComTamanhoDois;
begin
  CheckEquals(chr(18) + chr(52), AscToBcd('123456',2));
end;

procedure AscToBcdTest.AumentandoComtamanhoQuatro;
begin
  CheckEquals(chr(00) + chr(18) + chr(52) + chr(86), AscToBcd('123456',4));
end;

{ BcdToAscTest }

procedure BcdToAscTest.Normal;
begin
  CheckEquals('123456', BcdToAsc(chr(18) + chr(52) + chr(86)));
end;

procedure BcdToAscTest.ComZerosAEsquerda;
begin
  CheckEquals('00000000123456', BcdToAsc(chr(00)+chr(00)+chr(00)+chr(00)+chr(18)+chr(52)+chr(86)));
end;

{ BinToIntTest }

procedure BinToIntTest.TestarTodosBits;
begin
  CheckEquals(0, BinToInt('00000000') );
  CheckEquals(0, BinToInt('0000') );
  CheckEquals(0, BinToInt('0') );
  CheckEquals(1, BinToInt('0001') );
  CheckEquals(1, BinToInt('00000001') );
  CheckEquals(1, BinToInt('1') );
  CheckEquals(4, BinToInt('0100') );
  CheckEquals(15, BinToInt('1111') );
  CheckEquals(100, BinToInt('01100100') );
  CheckEquals(255, BinToInt('11111111') );
end;

{ IntToBinTest }

procedure IntToBinTest.TestarTodosBits;
begin
  CheckEquals('0001', IntToBin(1,4) );
  CheckEquals('0100', IntToBin(4,4) );
  CheckEquals('1111', IntToBin(15,4) );
  CheckEquals('00000000', IntToBin(0,8) );
  CheckEquals('01100100', IntToBin(100,8) );
  CheckEquals('11111111', IntToBin(255,8) );
end;

{ TestBitTest }

procedure TestBitTest.TestarTodosBits;
begin
  CheckTrue( TestBit(1,0));
  CheckTrue( TestBit(2,1));
  CheckTrue( TestBit(3,0));
  CheckTrue( TestBit(3,1));
  CheckTrue( TestBit(4,2));
  CheckTrue( TestBit(5,0));
  CheckTrue( TestBit(5,2));
  CheckTrue( TestBit(6,2));
  CheckTrue( TestBit(6,1));
  CheckTrue( TestBit(7,2));
  CheckTrue( TestBit(7,1));
  CheckTrue( TestBit(7,0));
  CheckTrue( TestBit(8,3));
  CheckTrue( TestBit(9,3));
  CheckTrue( TestBit(9,0));
  CheckTrue( TestBit(10,3));
  CheckTrue( TestBit(10,1));
  CheckTrue( TestBit(11,3));
  CheckTrue( TestBit(11,1));
  CheckTrue( TestBit(11,0));
  CheckTrue( TestBit(12,3));
  CheckTrue( TestBit(12,2));
  CheckTrue( TestBit(13,3));
  CheckTrue( TestBit(13,2));
  CheckTrue( TestBit(13,0));
  CheckTrue( TestBit(14,3));
  CheckTrue( TestBit(14,2));
  CheckTrue( TestBit(14,1));
  CheckTrue( TestBit(15,3));
  CheckTrue( TestBit(15,2));
  CheckTrue( TestBit(15,1));
  CheckTrue( TestBit(15,0));
  CheckTrue( TestBit(255,0));
  CheckTrue( TestBit(255,1));
  CheckTrue( TestBit(255,2));
  CheckTrue( TestBit(255,3));
  CheckTrue( TestBit(255,4));
  CheckTrue( TestBit(255,5));
  CheckTrue( TestBit(255,6));
  CheckTrue( TestBit(255,7));
end;

{ RoundABNTTest }

procedure RoundABNTTest.AsIntegerImpar;
begin
  CheckEquals( 5, RoundABNT(5.1, 0));
  CheckEquals( 5, RoundABNT(5.2, 0));
  CheckEquals( 5, RoundABNT(5.3, 0));
  CheckEquals( 5, RoundABNT(5.4, 0));
  CheckEquals( 6, RoundABNT(5.5, 0));
  CheckEquals( 6, RoundABNT(5.6, 0));
  CheckEquals( 6, RoundABNT(5.7, 0));
  CheckEquals( 6, RoundABNT(5.8, 0));
  CheckEquals( 6, RoundABNT(5.9, 0));
end;

procedure RoundABNTTest.AsIntegerPar;
begin
  CheckEquals( 4, RoundABNT(4.1, 0));
  CheckEquals( 4, RoundABNT(4.2, 0));
  CheckEquals( 4, RoundABNT(4.3, 0));
  CheckEquals( 4, RoundABNT(4.4, 0));
  CheckEquals( 4, RoundABNT(4.5, 0));
  CheckEquals( 5, RoundABNT(4.501, 0));
  CheckEquals( 5, RoundABNT(4.6, 0));
  CheckEquals( 5, RoundABNT(4.7, 0));
  CheckEquals( 5, RoundABNT(4.8, 0));
  CheckEquals( 5, RoundABNT(4.9, 0));
end;

procedure RoundABNTTest.TresParaDuasCasasDecimais;
begin
  CheckEquals( 5.10, RoundABNT(5.101, 2));
  CheckEquals( 5.10, RoundABNT(5.102, 2));
  CheckEquals( 5.10, RoundABNT(5.103, 2));
  CheckEquals( 5.10, RoundABNT(5.104, 2));
  CheckEquals( 5.10, RoundABNT(5.105, 2));
  CheckEquals( 5.11, RoundABNT(5.1050123, 2));
  CheckEquals( 5.11, RoundABNT(5.106, 2));
  CheckEquals( 5.11, RoundABNT(5.107, 2));
  CheckEquals( 5.11, RoundABNT(5.108, 2));
  CheckEquals( 5.11, RoundABNT(5.109, 2));
end;

procedure RoundABNTTest.QuatroParaDuasCasasDecimais;
begin
  CheckEquals( 5.10, RoundABNT(5.1010, 2));
  CheckEquals( 5.10, RoundABNT(5.1011, 2));
  CheckEquals( 5.10, RoundABNT(5.1012, 2));
  CheckEquals( 5.10, RoundABNT(5.1013, 2));
  CheckEquals( 5.10, RoundABNT(5.1014, 2));
  CheckEquals( 5.10, RoundABNT(5.1015, 2));
  CheckEquals( 5.10, RoundABNT(5.1016, 2));
  CheckEquals( 5.10, RoundABNT(5.1017, 2));
  CheckEquals( 5.10, RoundABNT(5.1018, 2));
  CheckEquals( 5.10, RoundABNT(5.1019, 2));

  CheckEquals( 5.10, RoundABNT(5.1020, 2));
  CheckEquals( 5.10, RoundABNT(5.1021, 2));
  CheckEquals( 5.10, RoundABNT(5.1022, 2));
  CheckEquals( 5.10, RoundABNT(5.1023, 2));
  CheckEquals( 5.10, RoundABNT(5.1024, 2));
  CheckEquals( 5.10, RoundABNT(5.1025, 2));
  CheckEquals( 5.10, RoundABNT(5.1026, 2));
  CheckEquals( 5.10, RoundABNT(5.1027, 2));
  CheckEquals( 5.10, RoundABNT(5.1028, 2));
  CheckEquals( 5.10, RoundABNT(5.1029, 2));

  CheckEquals( 5.10, RoundABNT(5.1030, 2));
  CheckEquals( 5.10, RoundABNT(5.1031, 2));
  CheckEquals( 5.10, RoundABNT(5.1032, 2));
  CheckEquals( 5.10, RoundABNT(5.1033, 2));
  CheckEquals( 5.10, RoundABNT(5.1034, 2));
  CheckEquals( 5.10, RoundABNT(5.1035, 2));
  CheckEquals( 5.10, RoundABNT(5.1036, 2));
  CheckEquals( 5.10, RoundABNT(5.1037, 2));
  CheckEquals( 5.10, RoundABNT(5.1038, 2));
  CheckEquals( 5.10, RoundABNT(5.1039, 2));

  CheckEquals( 5.10, RoundABNT(5.1040, 2));
  CheckEquals( 5.10, RoundABNT(5.1041, 2));
  CheckEquals( 5.10, RoundABNT(5.1042, 2));
  CheckEquals( 5.10, RoundABNT(5.1043, 2));
  CheckEquals( 5.10, RoundABNT(5.1044, 2));
  CheckEquals( 5.10, RoundABNT(5.1045, 2));
  CheckEquals( 5.10, RoundABNT(5.1046, 2));
  CheckEquals( 5.10, RoundABNT(5.1047, 2));
  CheckEquals( 5.10, RoundABNT(5.1048, 2));
  CheckEquals( 5.10, RoundABNT(5.1049, 2));

  CheckEquals( 5.10, RoundABNT(5.1050, 2));
  CheckEquals( 5.11, RoundABNT(5.1051, 2));
  CheckEquals( 5.11, RoundABNT(5.1052, 2));
  CheckEquals( 5.11, RoundABNT(5.1053, 2));
  CheckEquals( 5.11, RoundABNT(5.1054, 2));
  CheckEquals( 5.11, RoundABNT(5.1055, 2));
  CheckEquals( 5.11, RoundABNT(5.1056, 2));
  CheckEquals( 5.11, RoundABNT(5.1057, 2));
  CheckEquals( 5.11, RoundABNT(5.1058, 2));
  CheckEquals( 5.11, RoundABNT(5.1059, 2));

  CheckEquals( 5.11, RoundABNT(5.1060, 2));
  CheckEquals( 5.11, RoundABNT(5.1061, 2));
  CheckEquals( 5.11, RoundABNT(5.1062, 2));
  CheckEquals( 5.11, RoundABNT(5.1063, 2));
  CheckEquals( 5.11, RoundABNT(5.1064, 2));
  CheckEquals( 5.11, RoundABNT(5.1065, 2));
  CheckEquals( 5.11, RoundABNT(5.1066, 2));
  CheckEquals( 5.11, RoundABNT(5.1067, 2));
  CheckEquals( 5.11, RoundABNT(5.1068, 2));
  CheckEquals( 5.11, RoundABNT(5.1069, 2));

  CheckEquals( 5.11, RoundABNT(5.1070, 2));
  CheckEquals( 5.11, RoundABNT(5.1071, 2));
  CheckEquals( 5.11, RoundABNT(5.1072, 2));
  CheckEquals( 5.11, RoundABNT(5.1073, 2));
  CheckEquals( 5.11, RoundABNT(5.1074, 2));
  CheckEquals( 5.11, RoundABNT(5.1075, 2));
  CheckEquals( 5.11, RoundABNT(5.1076, 2));
  CheckEquals( 5.11, RoundABNT(5.1077, 2));
  CheckEquals( 5.11, RoundABNT(5.1078, 2));
  CheckEquals( 5.11, RoundABNT(5.1079, 2));

  CheckEquals( 5.11, RoundABNT(5.1080, 2));
  CheckEquals( 5.11, RoundABNT(5.1081, 2));
  CheckEquals( 5.11, RoundABNT(5.1082, 2));
  CheckEquals( 5.11, RoundABNT(5.1083, 2));
  CheckEquals( 5.11, RoundABNT(5.1084, 2));
  CheckEquals( 5.11, RoundABNT(5.1085, 2));
  CheckEquals( 5.11, RoundABNT(5.1086, 2));
  CheckEquals( 5.11, RoundABNT(5.1087, 2));
  CheckEquals( 5.11, RoundABNT(5.1088, 2));
  CheckEquals( 5.11, RoundABNT(5.1089, 2));

  CheckEquals( 5.11, RoundABNT(5.1090, 2));
  CheckEquals( 5.11, RoundABNT(5.1091, 2));
  CheckEquals( 5.11, RoundABNT(5.1092, 2));
  CheckEquals( 5.11, RoundABNT(5.1093, 2));
  CheckEquals( 5.11, RoundABNT(5.1094, 2));
  CheckEquals( 5.11, RoundABNT(5.1095, 2));
  CheckEquals( 5.11, RoundABNT(5.1096, 2));
  CheckEquals( 5.11, RoundABNT(5.1097, 2));
  CheckEquals( 5.11, RoundABNT(5.1098, 2));
  CheckEquals( 5.11, RoundABNT(5.1099, 2));
end;

{ TruncFixTest }

procedure TruncFixTest.AsExpression;
begin
  CheckEquals( 156, TruncFix( 1.602 * 0.98 * 100) );
  CheckEquals( 64, TruncFix( 5 * 12.991) );
  CheckEquals( 49, TruncFix( 2.09 * 23.5) );
end;

procedure TruncFixTest.AsDouble;
var
  ADouble: Double;
begin
  ADouble := 1.602 * 0.98 * 100;
  CheckEquals( 156, TruncFix( ADouble ) );
  ADouble := 5 * 12.991;
  CheckEquals( 64, TruncFix( ADouble ) );
  ADouble := 2.09 * 23.5;
  CheckEquals( 49, TruncFix( ADouble ) );
end;

procedure TruncFixTest.AsExtended;
var
  AExtended: Extended;
begin
  AExtended := 1.602 * 0.98 * 100;
  CheckEquals( 156, TruncFix( AExtended ) );
  AExtended := 5 * 12.991;
  CheckEquals( 64, TruncFix( AExtended ) );
  AExtended := 2.09 * 23.5;
  CheckEquals( 49, TruncFix( AExtended ) );
end;

procedure TruncFixTest.AsCurrency;
var
  ACurr: Currency;
begin
  ACurr := 1.602 * 0.98 * 100;
  CheckEquals( 156, TruncFix( ACurr ) );
  ACurr := 5 * 12.991;
  CheckEquals( 64, TruncFix( ACurr ) );
  ACurr := 2.09 * 23.5;
  CheckEquals( 49, TruncFix( ACurr ) );
end;

{ ACBrStrToAnsiTest }

procedure ACBrStrToAnsiTest.TesteUTF8;
Var
  UTF8Str : AnsiString;
begin
  UTF8Str := UTF8Encode('�����');  // Nota: essa Unit usa CP1252
  CheckEquals( '�����', ACBrStrToAnsi(UTF8Str) );
end;

procedure ACBrStrToAnsiTest.TesteReverso;
begin
  CheckEquals( '�����', ACBrStrToAnsi(ACBrStr('�����')) );
end;

{ ACBrStrTest }

procedure ACBrStrTest.TesteUTF8;
Var
  UTF8Str : AnsiString;
begin
  UTF8Str := UTF8Encode('�����');  // Nota: essa Unit usa CP1252
  CheckEquals( UTF8Str, ACBrStr('�����'));
end;

procedure ACBrStrTest.TesteAnsi;
begin
  CheckEquals( '�����', UTF8Decode(ACBrStr('�����')) );
end;

{ DecodeToStringTest }

procedure DecodeToStringTest.TesteUTF8;
Var
  UTF8Str : AnsiString;
begin
  UTF8Str := UTF8Encode('�����');  // Nota: essa Unit usa CP1252
  CheckEquals(ACBrStr('�����'), DecodeToString(UTF8Str, True));
end;

procedure DecodeToStringTest.TesteAnsi;
Var
  AnsiStr : AnsiString;
begin
  AnsiStr := '�����';  // Nota: essa Unit usa CP1252
  CheckEquals(ACBrStr('�����'), DecodeToString(AnsiStr, False));
end;

{ TiraAcentoTest }

procedure TiraAcentoTest.Normal;
begin
   CheckEquals('a', TiraAcento('�'));
   CheckEquals('a', TiraAcento('�'));
   CheckEquals('a', TiraAcento('�'));
   CheckEquals('a', TiraAcento('�'));
   CheckEquals('a', TiraAcento('�'));
   CheckEquals('A', TiraAcento('�'));
   CheckEquals('A', TiraAcento('�'));
   CheckEquals('A', TiraAcento('�'));
   CheckEquals('A', TiraAcento('�'));
   CheckEquals('A', TiraAcento('�'));
   CheckEquals('e', TiraAcento('�'));
   CheckEquals('e', TiraAcento('�'));
   CheckEquals('e', TiraAcento('�'));
   CheckEquals('e', TiraAcento('�'));
   CheckEquals('E', TiraAcento('�'));
   CheckEquals('E', TiraAcento('�'));
   CheckEquals('E', TiraAcento('�'));
   CheckEquals('E', TiraAcento('�'));
   CheckEquals('i', TiraAcento('�'));
   CheckEquals('i', TiraAcento('�'));
   CheckEquals('i', TiraAcento('�'));
   CheckEquals('i', TiraAcento('�'));
   CheckEquals('I', TiraAcento('�'));
   CheckEquals('I', TiraAcento('�'));
   CheckEquals('I', TiraAcento('�'));
   CheckEquals('I', TiraAcento('�'));
   CheckEquals('o', TiraAcento('�'));
   CheckEquals('o', TiraAcento('�'));
   CheckEquals('o', TiraAcento('�'));
   CheckEquals('o', TiraAcento('�'));
   CheckEquals('o', TiraAcento('�'));
   CheckEquals('O', TiraAcento('�'));
   CheckEquals('O', TiraAcento('�'));
   CheckEquals('O', TiraAcento('�'));
   CheckEquals('O', TiraAcento('�'));
   CheckEquals('O', TiraAcento('�'));
   CheckEquals('u', TiraAcento('�'));
   CheckEquals('u', TiraAcento('�'));
   CheckEquals('u', TiraAcento('�'));
   CheckEquals('u', TiraAcento('�'));
   CheckEquals('U', TiraAcento('�'));
   CheckEquals('U', TiraAcento('�'));
   CheckEquals('U', TiraAcento('�'));
   CheckEquals('U', TiraAcento('�'));
   CheckEquals('c', TiraAcento('�'));
   CheckEquals('C', TiraAcento('�'));
   CheckEquals('n', TiraAcento('�'));
   CheckEquals('N', TiraAcento('�'));
end;

{ TiraAcentosTest }

procedure TiraAcentosTest.Normal;
begin
  CheckEquals('TesteACBrUtil', TiraAcentos( ACBrStr('T�st��CBr�t�l')) );
end;

{ StrIsIPTest }

procedure StrIsIPTest.Normal;
begin
  CheckTrue(StrIsIP('192.168.0.1'));
  CheckTrue(StrIsIP('192.168.000.001'));
  CheckTrue(StrIsIP('127.0.0.1'));
end;

procedure StrIsIPTest.SemPonto;
begin
   CheckFalse(StrIsIP('19216801'));
end;

procedure StrIsIPTest.ComNome;
begin
  CheckFalse(StrIsIP('hostname'));
end;

procedure StrIsIPTest.Errados;
begin
  CheckFalse(StrIsIP('192168.0.1'));
  CheckFalse(StrIsIP('192.168'));
end;

{ OnlyAlphaNumTest }

procedure OnlyAlphaNumTest.Texto;
begin
  CheckEquals('TesteACBr', OnlyAlphaNum('TesteACBr'));
end;

procedure OnlyAlphaNumTest.Numeros;
begin
  CheckEquals('12345', OnlyAlphaNum('12345'));
end;

procedure OnlyAlphaNumTest.TextoComNumeros;
begin
  CheckEquals('TesteACBr12345', OnlyAlphaNum('TesteACBr12345'));
end;

procedure OnlyAlphaNumTest.TextoComCaractersEspeciais;
begin
  CheckEquals('TesteACBr12345', OnlyAlphaNum('T!e@s#t$e%A&C*B(r)1_2-3=4+5"'));
end;

{ OnlyAlphaTest }

procedure OnlyAlphaTest.Texto;
begin
  CheckEquals('TesteACBr', OnlyAlpha('TesteACBr'));
end;

procedure OnlyAlphaTest.Numeros;
begin
  CheckEquals('', OnlyAlpha('12345'));
end;

procedure OnlyAlphaTest.TextoComNumeros;
begin
   CheckEquals('TesteACBr', OnlyAlpha('TesteACBr12345'));
end;

procedure OnlyAlphaTest.TextoComCaractersEspeciais;
begin
   CheckEquals('TesteACBr', OnlyAlpha('T!e@s#t$e%A&C*B(r)'));
end;

{ OnlyNumberTest }

procedure OnlyNumberTest.Texto;
begin
   CheckEquals('', OnlyNumber('TesteACBr'));
end;

procedure OnlyNumberTest.Numeros;
begin
   CheckEquals('12345', OnlyNumber('12345'));
end;

procedure OnlyNumberTest.TextoComNumeros;
begin
   CheckEquals('12345', OnlyNumber('TesteACBr12345'));
end;

procedure OnlyNumberTest.TextoComSeparadores;
begin
   CheckEquals('1234500', OnlyNumber('1.2345,00'));
end;

procedure OnlyNumberTest.TextoComCaractersEspeciais;
begin
  CheckEquals('12345', OnlyNumber('!1@2#34$5%'));
end;

{ CharIsNumTest }

procedure CharIsNumTest.Caracter;
begin
  CheckFalse(CharIsNum('A'));
end;

procedure CharIsNumTest.Numero;
begin
  CheckTrue(CharIsNum('1'));
end;

procedure CharIsNumTest.CaracterEspecial;
begin
  CheckFalse(CharIsNum('#'));
end;

{ CharIsAlphaNumTest }

procedure CharIsAlphaNumTest.Caracter;
begin
  CheckTrue(CharIsAlphaNum('A'));
end;

procedure CharIsAlphaNumTest.Numero;
begin
  CheckTrue(CharIsAlphaNum('1'));
end;

procedure CharIsAlphaNumTest.CaracterEspecial;
begin
  CheckFalse(CharIsAlphaNum('#'));
end;

{ CharIsAlphaTest }

procedure CharIsAlphaTest.Caracter;
begin
  CheckTrue(CharIsAlpha('A'));
end;

procedure CharIsAlphaTest.Numero;
begin
  CheckFalse(CharIsAlpha('1'));
end;

procedure CharIsAlphaTest.CaracterEspecial;
begin
  CheckFalse(CharIsAlpha('#'));
end;

{ StrIsNumberTest }

procedure StrIsNumberTest.Texto;
begin
  CheckFalse(StrIsNumber('TesteACBrUtil'));
end;

procedure StrIsNumberTest.Numeros;
begin
  CheckTrue(StrIsNumber('0123456789'));
end;

procedure StrIsNumberTest.TextoComSeparadores;
begin
   CheckFalse(StrIsNumber('1.2345,00'));
end;

procedure StrIsNumberTest.TextoComNumeros;
begin
   CheckFalse(StrIsNumber('TesteACBrUtil1234'));
end;

procedure StrIsNumberTest.TextoComCaractersEspeciais;
begin
   CheckFalse(StrIsNumber('_%#$@$*&!""'));
end;

{ StrIsAlphaNumTest }

procedure StrIsAlphaNumTest.Texto;
begin
  CheckTrue(StrIsAlphaNum('TesteACBrUtil'));
end;

procedure StrIsAlphaNumTest.TextoComNumeros;
begin
  CheckTrue(StrIsAlphaNum('TesteACBrUtil1234'));
end;

procedure StrIsAlphaNumTest.TextoComCaractersEspeciais;
begin
  CheckFalse(StrIsAlphaNum('_%#$@$*&!""'));
end;

procedure StrIsAlphaNumTest.TextoComCaractersAcentuados;
begin
  CheckFalse(StrIsAlphaNum('TesteACBrÚtil'));
end;

{ StrIsAlphaTest }

procedure StrIsAlphaTest.Texto;
begin
  CheckTrue(StrIsAlpha('TesteACBrUtil'));
end;

procedure StrIsAlphaTest.TextoComNumeros;
begin
  CheckFalse(StrIsAlpha('TesteACBrUtil1234'));
end;

procedure StrIsAlphaTest.TextoComCaractersEspeciais;
begin
  CheckFalse(StrIsAlpha('_%#$@$*&!""'));
end;

procedure StrIsAlphaTest.TextoComCaractersAcentuados;
begin
  CheckFalse(StrIsAlpha('TesteACBrÚtil'));
end;

{ DTtoSTest }

procedure DTtoSTest.DataEHora;
var
  Date: TDateTime;
begin
  Date := EncodeDateTime(2015,01,14,12,51,49,0);
  CheckEquals('20150114125149', DTtoS(Date));;
end;

procedure DTtoSTest.DataSemHora;
var
  Date: TDateTime;
begin
  Date := EncodeDate(2015,01,14);
  CheckEquals('20150114000000', DTtoS(Date));
end;

{ DtoSTest }

procedure DtoSTest.Data;
var
  Date: TDateTime;
begin
  Date := EncodeDate(2015,01,14);
  CheckEquals('20150114', DtoS(Date));
end;

{ StoDTest }

procedure StoDTest.Normal;
var
  Date: TDateTime;
begin
  Date := EncodeDateTime(2015,01,14,16,28,12,0);
  CheckEquals(Date, StoD('20150114162812'));
end;

procedure StoDTest.DataSemHora;
var
  Date: TDateTime;
begin
  Date := EncodeDate(2015,01,14);
  CheckEquals(Date, StoD('20150114'));
end;

procedure StoDTest.DataInvalida;
begin
  CheckEquals(0, StoD('DataInvalida'));
end;

{ StringToDateTimeDefTest }

procedure StringToDateTimeDefTest.Data;
var
  Date: TDateTime;
begin
  Date := EncodeDate(2015,01,02);
  CheckEquals(Date, StringToDateTimeDef('02/01/2015', Date));
end;

procedure StringToDateTimeDefTest.Hora;
var
  Date: TDateTime;
begin
  Date := EncodeTime(12,45,12,0);
  CheckEquals(Date, StringToDateTimeDef('12:45:12', Date));
end;

procedure StringToDateTimeDefTest.DataEHora;
var
  Date: TDateTime;
begin
  Date := EncodeDateTime(2015,01,14,12,45,12,0);
  CheckEquals(Date, StringToDateTimeDef('14/01/2015 12:45:12', Date));
end;

procedure StringToDateTimeDefTest.ValorDefault;
var
  Date: TDateTime;
begin
  Date := EncodeDateTime(2015,01,14,12,45,12,0);
  CheckEquals(Date, StringToDateTimeDef('99/99/2001 00:01:12', Date));
end;

{ StringToDateTimeTest }

procedure StringToDateTimeTest.Data;
var
  Date: TDateTime;
begin
  Date := StrToDate('01/01/2015');
  CheckEquals(Date, StringToDateTime('01/01/2015'));
end;

procedure StringToDateTimeTest.Hora;
var
  Date: TDateTime;
begin
  Date := StrToTime('12:45:12');
  CheckEquals(Date, StringToDateTime('12:45:12'));
end;

procedure StringToDateTimeTest.DataEHora;
var
  Date: TDateTime;
begin
  Date := StrToDateTime('14/01/2015 12:45:12');
  CheckEquals(Date, StringToDateTime('14/01/2015 12:45:12'));
end;

{ StringToFloatDefTest }

procedure StringToFloatDefTest.ComVirgula;
begin
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 1));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.1));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.01));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.0001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.00001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.000001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.0000001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123,45', 0), 0.00000000001));
end;

procedure StringToFloatDefTest.ComPonto;
begin
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 1));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.1));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.01));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.0001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.00001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.000001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.0000001));
  CheckTrue(SameValue(123.45, StringToFloatDef('123.45', 0), 0.00000000001));
end;

procedure StringToFloatDefTest.ApenasInteiro;
begin
  CheckEquals(123, StringToFloatDef('123', 0));
end;

procedure StringToFloatDefTest.ValorDefault;
begin
  CheckEquals(0, StringToFloatDef('12,12,1', 0));
  CheckEquals(10, StringToFloatDef('ewerwt', 10));
end;

{ StringToFloatTest }

procedure StringToFloatTest.ComVirgula;
begin
  CheckEquals(123.45, StringToFloat('123,45'));
end;

procedure StringToFloatTest.ComPonto;
begin
  CheckEquals(123.45, StringToFloat('123.45'));
end;

procedure StringToFloatTest.ApenasInteiro;
begin
  CheckEquals(123.00, StringToFloat('123'));
end;


{ FloatToStringTest }

procedure FloatToStringTest.Normal;
begin
  CheckEquals('115.89', FloatToString(115.89));
end;

procedure FloatToStringTest.ComDecimaisZerados;
begin
  CheckEquals('115', FloatToString(115.00));
end;

procedure FloatToStringTest.MudandoPontoDecimal;
begin
  CheckEquals('115,89', FloatToString(115.89, ','));
end;

procedure FloatToStringTest.ComFormatacao;
begin
  CheckEquals('115,890', FloatToString(115.89, ',', '0.000'));
end;

procedure FloatToStringTest.RemovendoSerparadorDeMilhar;
begin
  CheckEquals('123456.789', FloatToString(123456.789, '.', '###,000.000'));
end;

{ FloatToIntStrTest }

procedure FloatToIntStrTest.Normal;
begin
  CheckEquals('12345', FloatToIntStr(123.45));
end;

procedure FloatToIntStrTest.ValorDecimaisDefault;
begin
  CheckEquals('1234500', FloatToIntStr(12345));
end;

procedure FloatToIntStrTest.MudandoPadraoDeDecimais;
begin
  CheckEquals('12345000', FloatToIntStr(123.45, 5));
end;

procedure FloatToIntStrTest.SemDecimais;
begin
  CheckEquals('123', FloatToIntStr(123.453,0));
end;

procedure FloatToIntStrTest.ValorComMaisDecimais;
begin
  CheckEquals('12345', FloatToIntStr(123.453678,2));
end;

{ IntToStrZeroTest }

procedure IntToStrZeroTest.AdicionarZerosAoNumero;
begin
  CheckEquals('0000000123', IntToStrZero(123, 10));
end;

procedure IntToStrZeroTest.TamanhoMenorQueLimite;
begin
  CheckEquals('98', IntToStrZero(987, 2));
end;

{ Poem_ZerosTest }

procedure Poem_ZerosTest.ParamString;
begin
  CheckEquals('001', Poem_Zeros('1', 3));
  CheckEquals('000000TesteACBr', Poem_Zeros('TesteACBr', 15));
  CheckEquals('000000000000000', Poem_Zeros('', 15));
end;

procedure Poem_ZerosTest.Truncando;
begin
  CheckEquals('123', Poem_Zeros('12345', 3));
end;

procedure Poem_ZerosTest.ParamInt64;
begin
  CheckEquals('001', Poem_Zeros(1, 3));
  CheckEquals('123', Poem_Zeros(12345, 3));
  CheckEquals('000000000000000', Poem_Zeros(0, 15));
end;

{ IfEmptyThenTest }

procedure IfEmptyThenTest.RetornarValorNormal;
begin
  CheckEquals('ACBrTeste', IfEmptyThen('ACBrTeste', 'ValorPadrao'));
end;

procedure IfEmptyThenTest.SeVazioRetornaValorPadrao;
begin
  CheckEquals('ValorPadrao', IfEmptyThen('', 'ValorPadrao'));
end;

procedure IfEmptyThenTest.RealizarDoTrim;
begin
  CheckEquals('ValorPadrao', IfEmptyThen('      ', 'ValorPadrao', true));
  CheckEquals('ValorPadrao', IfEmptyThen('      ', 'ValorPadrao'));
end;

procedure IfEmptyThenTest.NaoRealizarDoTrim;
begin
  CheckEquals('ACBrTeste  ', IfEmptyThen('ACBrTeste  ', 'ValorPadrao', false));
end;

{ CompareVersionsTest }

procedure CompareVersionsTest.VersaoIgual;
begin
   CheckEquals(0, CompareVersions('1.3.1' , '1.3.1'));
end;

procedure CompareVersionsTest.VersaoMaior;
begin
   CheckEquals(11, CompareVersions('1.3.4' , '1.2.1'));
end;

procedure CompareVersionsTest.VersaoMenor;
begin
   CheckEquals(-11, CompareVersions('1.2.1' , '1.3.4'));
end;

procedure CompareVersionsTest.TrocarDelimitador;
begin
   CheckEquals(-109, CompareVersions('1-4-9', '3-8-7', '-'));
end;

procedure CompareVersionsTest.NomeclaturaDiferente;
begin
  CheckEquals(-1, CompareVersions('1.0.3', '01.00.04'));
  CheckEquals(11, CompareVersions('1.2.5', '01.01.04'));
  CheckEquals(-11, CompareVersions('1.2.3', '01.10.5555'));
  CheckEquals(1, CompareVersions('8', '1'));
  CheckEquals(91, CompareVersions('2.3.7', '1.9'));
  CheckEquals(89110889, CompareVersions('2.0.0.9.8.6', '0.9.9.7.6.5.34.3.2'));
  CheckEquals(-1, CompareVersions('1.2a', '1.2d'));
end;

{ StripHTMLTest }

procedure StripHTMLTest.TesteSimples;
begin
  CheckEquals('Teste string em html', StripHTML('<br><b>Teste string em html</b><br>'));
end;

procedure StripHTMLTest.TesteCompleto;
begin
  CheckEquals('FPCUnit de TestesACBrUtil, Testes Unit�rios', StripHTML('<!DOCTYPE html>'
                           +'<html>'
                               +'<head>'
                                   +'FPCUnit de Testes'
                               +'</head>'
                               +'<body>'
                                   +'ACBrUtil, Testes Unit�rios'
                               +'</body>'
                           +'</html>'));
end;

{ RemoveStringsTest }

procedure RemoveStringsTest.SetUp;
begin
  StringsToRemove[1] := 'a';
  StringsToRemove[2] := 'b';
  StringsToRemove[3] := 'c';
  StringsToRemove[4] := 'te';
  StringsToRemove[5] := 'AC';
end;

procedure RemoveStringsTest.TextoSimples;
begin
  CheckEquals('s', RemoveStrings('testeabc', StringsToRemove));
end;

procedure RemoveStringsTest.TextoLongo;
begin
  CheckEquals('Tes Unitrio BrUtil ', RemoveStrings('Teste Unitario ACBrUtil ', StringsToRemove));
end;

{ RemoveStringTest }

procedure RemoveStringTest.Remover;
begin
  CheckEquals('TstACBr', RemoveString('e', 'TesteACBr'));
  CheckEquals('#####', RemoveString('ACBr', '#ACBr#ACBr#ACBr#ACBr#'));
end;

{ RemoverEspacosDuplosTest }

procedure RemoverEspacosDuplosTest.RemoverApenasEspacosDuplos;
begin
  CheckEquals('Teste ACBr', RemoverEspacosDuplos('  Teste  ACBr  '));
end;

procedure RemoverEspacosDuplosTest.RemoverMaisQueDoisEspacos;
begin
  CheckEquals('Teste ACBr Com FPCUnit', RemoverEspacosDuplos('Teste    ACBr Com  FPCUnit     '));
end;

{ padSpaceTest }

procedure padSpaceTest.CompletarString;
begin
  CheckEquals('TesteACBrZZZZZZ', PadSpace('TesteACBr', 15, '|', 'Z'));
  CheckEquals('TesteACBr      ', PadSpace('TesteACBr', 15, '|'));
end;

procedure padSpaceTest.TruncarString;
begin
  CheckEquals('TesteACBr', PadSpace('TesteACBrZZZZZZ', 9, '|'));
end;

procedure padSpaceTest.SubstituirSeparadorPorEspacos;
begin
  CheckEquals(' Teste Unitario ACBr ', PadSpace('|Teste|Unitario|ACBr|', 21, '|'));
  CheckEquals('   Teste   Unitario   ACBr    ', PadSpace('|Teste|Unitario|ACBr|', 30, '|'));
end;

procedure padSpaceTest.SubstituirSeparadorPorCaracter;
begin
  CheckEquals('ZTesteZUnitarioZACBrZ', PadSpace('|Teste|Unitario|ACBr|', 21, '|', 'Z'));
  CheckEquals('ZZZTesteZZZUnitarioZZZACBrZZZZ', PadSpace('|Teste|Unitario|ACBr|', 30, '|', 'Z'));
end;

{ padCenterTest }

procedure padCenterTest.PreencherString;
begin
  CheckEquals('ZZZTESTEZZZZ', PadCenter('TESTE', 12, 'Z'));
  CheckEquals('ZZZZTESTEZZZZ', PadCenter('TESTE', 13, 'Z'));
  CheckEquals('    TESTE    ', PadCenter('TESTE', 13));
end;

procedure padCenterTest.TruncarString;
begin
  CheckEquals('TesteACBr', PadCenter('TesteACBrUtil', 9));
end;

{ padLeftTest }

procedure padLeftTest.CompletarString;
begin
  CheckEquals('ZZZACBrCompletaString', PadLeft('ACBrCompletaString', 21, 'Z'));
  CheckEquals('   ACBrCompletaString', PadLeft('ACBrCompletaString', 21));
end;

procedure padLeftTest.ManterString;
begin
  CheckEquals('ACBrMantemString', PadLeft('ACBrMantemString', 16, 'Z'));
end;

procedure padLeftTest.TruncarString;
begin
  CheckEquals('TruncaString', PadLeft('ACBrTruncaString', 12, 'Z'));
end;

{ padRightTest }

procedure padRightTest.CompletarString;
begin
  CheckEquals('ACBrCompletaStringZZZ', PadRight('ACBrCompletaString', 21, 'Z'));
  CheckEquals('ACBrCompletaString   ', PadRight('ACBrCompletaString', 21));
end;

procedure padRightTest.ManterString;
begin
  CheckEquals('ACBrMantemString', PadRight('ACBrMantemString', 16, 'Z'));
end;

procedure padRightTest.TruncarString;
begin
  CheckEquals('ACBrTrunca', PadRight('ACBrTruncaString', 10, 'Z'));
end;

{ SepararDadosTest }

procedure SepararDadosTest.Simples;
begin
  CheckEquals('Teste Simples', SeparaDados('<ACBr>Teste Simples</ACBr>', 'ACBr'));
  CheckEquals('Teste     Simples', SeparaDados('<ACBr>Teste     Simples</ACBr>', 'ACBr'));
  CheckEquals('TesteSimples', SeparaDados('<ACBr>TesteSimples</ACBr>', 'ACBr'));
end;

procedure SepararDadosTest.TextoLongo;
begin
  CheckEquals('ACBr Util', SeparaDados('<ACBrUtil>Teste com texto longo <b>ACBr Util</b> feito por DJSystem</ACBrUtil>', 'b'));
  CheckEquals('#ACBrUtil', SeparaDados('<ACBrUtil>Teste com texto longo <b>#ACBrUtil</b> feito por DJSystem</ACBrUtil>', 'b'));
end;

procedure SepararDadosTest.MostrarChave;
begin
  CheckEquals('<ACBr>Teste Simples</ACBr>', SeparaDados('<ACBr>Teste Simples</ACBr>', 'ACBr',  true));
  CheckEquals('<ACBrTeste>Teste     Simples</ACBrTeste>', SeparaDados('<ACBrTeste>Teste     Simples</ACBrTeste>', 'ACBrTeste', true));
  CheckEquals('<ACBr>TesteSimples</ACBr>', SeparaDados('<ACBr>TesteSimples</ACBr>', 'ACBr', true));
  CheckEquals('<b>ACBr Util</b>', SeparaDados('<ACBrUtil>Teste com texto longo <b>ACBr Util</b> feito por DJSystem', 'b', true));
  CheckEquals('<u>#ACBrUtil</u>', SeparaDados('<ACBrUtil>Teste com texto longo <u>#ACBrUtil</u> feito por DJSystem', 'u', true));
end;

procedure SepararDadosTest.ComVariasChaves;
begin
  CheckEquals('ACBrUtil', SeparaDados('<ACBr>Teste <ACBrTeste>ACBrUtil</ACBrTeste> com <ACBrTeste>FPCUnit</ACBrTeste></ACBr>', 'ACBrTeste'));
end;

procedure SepararDadosTest.SemFecharChave;
begin
  CheckEquals('', SeparaDados('<ACBrUtil>Teste com texto longo <b>ACBr Util</b> realizado por FPCUnit', 'ACBrUtil'));
end;

procedure SepararDadosTest.SemAbrirChave;
begin
  CheckEquals('', SeparaDados('Teste com texto longo <b>ACBr Util</b> realizado por FPCUnit</ACBrUtil>', 'ACBrUtil'));
end;

procedure QuebrarLinhaTest.TresCampos;
Var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    QuebrarLinha('"CAMPO1";"CAMPO2";"CAMPO3"',SL);
    CheckEquals( 'CAMPO1', SL[0]);
    CheckEquals( 'CAMPO2', SL[1]);
    CheckEquals( 'CAMPO3', SL[2]);
  finally
    SL.Free;
  end;
end;

procedure QuebrarLinhaTest.PipeDelimiter;
Var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    QuebrarLinha('CAMPO1|CAMPO2|CAMPO3',SL, ' ', '|');
    CheckEquals( 'CAMPO1', SL[0] );
    CheckEquals( 'CAMPO2', SL[1] );
    CheckEquals( 'CAMPO3', SL[2] );
  finally
    SL.Free;
  end;
end;

{ LerTagXMLTest }

procedure LerTagXMLTest.Simples;
begin
  CheckEquals('Teste Simples', LerTagXML('<ACBr>Teste Simples</ACBr>', 'acbr'));
end;

procedure LerTagXMLTest.SemIgnorarCase;
begin
  CheckEquals('Teste sem ignorar case', LerTagXML('<ACBr>Teste sem ignorar case</ACBr>', 'ACBr', false));
  CheckEquals('', LerTagXML('<ACBr>Teste sem ignorar case</ACBr>', 'acbr', false));
  CheckEquals('Ler Aqui', LerTagXML('<ACBr>Teste sem <acbr>Ler Aqui</acbr> ignorar case</ACBr>', 'acbr', false));
end;

procedure LerTagXMLTest.ComVariasTags;
begin
  CheckEquals('mais um teste', LerTagXML('<ACBr> teste <br> outro teste </br> <b>mais um teste</b> </ACBr>', 'b'));
end;

{ ParseTextTest }

procedure ParseTextTest.ParseDecode;
begin
  CheckEquals('&', ParseText('&amp;'));
  CheckEquals('<', ParseText('&lt;'));
  CheckEquals('>', ParseText('&gt;'));
  CheckEquals('"', ParseText('&quot;'));
  CheckEquals(#39, ParseText('&#39;'));
  CheckEquals(ACBrStr('�'), ParseText('&aacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Aacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&acirc;',  True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Acirc;',  True, False));
  CheckEquals(ACBrStr('�'), ParseText('&atilde;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Atilde;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&agrave;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Agrave;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&eacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Eacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&ecirc;',  True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Ecirc;',  True, False));
  CheckEquals(ACBrStr('�'), ParseText('&iacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Iacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&oacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Oacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&otilde;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Otilde;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&ocirc;',  True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Ocirc;',  True, False));
  CheckEquals(ACBrStr('�'), ParseText('&uacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Uacute;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&uuml;',   True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Uuml;',   True, False));
  CheckEquals(ACBrStr('�'), ParseText('&ccedil;', True, False));
  CheckEquals(ACBrStr('�'), ParseText('&Ccedil;', True, False));
  CheckEquals('''', ParseText('&apos;',  True, False));
end;

procedure ParseTextTest.ParseEncode;
begin
  CheckEquals('&amp;', ParseText('&', False));
  CheckEquals('&lt;', ParseText('<', False));
  CheckEquals('&gt;', ParseText('>', False));
  CheckEquals('&quot;', ParseText('"', False));
  CheckEquals('&#39;', ParseText(#39, False));
end;

procedure ParseTextTest.VerificarConversaoTextoLongo;
begin
  CheckEquals('&<>"', ParseText('&amp;&lt;&gt;&quot;'));
  CheckEquals('&"<>', ParseText('&amp;&quot;&lt;&gt;'));
  CheckEquals('<&">', ParseText('&lt;&amp;&quot;&gt;'));
  CheckEquals( ACBrStr(#39'�������'''), ParseText('&#39;&aacute;&Atilde;&Ccedil;&Uuml;'
              + '&Eacute;&Ecirc;&Otilde;&apos;', True, False));
end;

initialization

  RegisterTest('ACBrComum.ACBrUtil', ParseTextTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', LerTagXMLTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', DecodeToStringTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', SepararDadosTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', QuebrarLinhaTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', ACBrStrTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', ACBrStrToAnsiTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', TruncFixTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', RoundABNTTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', CompareVersionsTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', TestBitTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', IntToBinTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', BinToIntTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', BcdToAscTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', AscToBcdTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', IntToLEStrTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', LEStrToIntTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', HexToAsciiTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', AsciiToHexTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', BinaryStringToStringTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StringToBinaryStringTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', padRightTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', padLeftTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', padCenterTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', padSpaceTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', RemoveStringTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', RemoveStringsTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', RemoverEspacosDuplosTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StripHTMLTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', RemoveEmptyLinesTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', RandomNameTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', IfEmptyThenTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', PosAtTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', PosLastTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', CountStrTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', Poem_ZerosTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', IntToStrZeroTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', FloatToIntStrTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', FloatToStringTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', FormatFloatBrTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', FloatMaskTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StringToFloatTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StringToFloatDefTest{$ifndef FPC}.Suite{$endif});

  (*
  RegisterTest('ACBrComum.ACBrUtil', TiraAcentoTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', TiraAcentosTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StrIsIPTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', OnlyNumberTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', OnlyAlphaTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', OnlyAlphaNumTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StrIsAlphaTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StrIsAlphaNumTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StrIsNumberTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', CharIsAlphaTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', CharIsAlphaNumTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', CharIsNumTest{$ifndef FPC}.suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StoDTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', DtoSTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', DTtoSTest{$ifndef FPC}.suite{$endif});

  RegisterTest('ACBrComum.ACBrUtil', StringToDateTimeTest{$ifndef FPC}.Suite{$endif});
  RegisterTest('ACBrComum.ACBrUtil', StringToDateTimeDefTest{$ifndef FPC}.Suite{$endif});
  *)
end.

