{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Juliana Rodrigues Prado                       }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBancoBanrisul;

interface

uses
  Classes, SysUtils,
  ACBrBoleto;

type

  { TACBrBancoBanrisul }

  TACBrBanrisul=class(TACBrBancoClass)
  Protected
  Public
    constructor create(AOwner: TACBrBanco);
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string; Override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; Override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; Override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); Override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); Override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); Override;
    function CalculaDigitosChaveASBACE(ChaveASBACESemDigito: string): string;
    procedure LerRetorno400(ARetorno: TStringList); override;
    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroTrailler240(ARemessa: TStringList): String; override;
    procedure LerRetorno240(ARetorno: TStringList); override;

    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: String): String;

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
  end;

implementation

uses
  {$IFDEF COMPILER6_UP}dateutils{$ELSE}ACBrD5{$ENDIF},
  StrUtils,
  ACBrUtil, ACBrValidador;

var
  aTotal: Extended;

{ TACBrBancoBanrisul }

constructor TACBrBanrisul.create(AOwner: TACBrBanco);
begin
  inherited create(AOwner);
  fpDigito:=8;
  fpNome:='Banrisul';
  fpNumero:= 041;
  fpTamanhoMaximoNossoNum:=8;

  fpTamanhoAgencia:= 4;
  fpTamanhoConta  := 7;
  fpTamanhoCarteira:= 1;

  fpCodigosMoraAceitos:='01';
  fpOrientacoesBanco.Clear;
  fpOrientacoesBanco.Add(ACBrStr('SAC       BANRISUL - 0800 646 1515'+sLineBreak+
                                 'OUVIDORIA BANRISUL - 0800 644 2200'));

end;

function Modulo11(Valor: string; Base: Integer=9; Resto: boolean=false): string;
var
  Soma, Contador, Peso, Digito: integer;
begin
  Soma:=0;
  Peso:=2;
  for Contador:=Length(Valor)downto 1 do
  begin
    Soma:=Soma+(StrToInt(Valor[Contador])*Peso);
    if Peso<Base then
      Peso:=Peso+1
    else
      Peso:=2;
  end;

  if Resto then
    Result:=IntToStr(Soma mod 11)
  else
  begin
    Digito:=11-(Soma mod 11);
    if (Digito>9) then
      Digito:=0;
    Result:=IntToStr(Digito);
  end
end;

function TACBrBanrisul.CalculaDigitosChaveASBACE(ChaveASBACESemDigito: string): string;
{Calcula os 2 d�gitos usados na CHAVE ASBACE - C�digo usado por bancos estaduais}
var
  Digito1, Digito2: integer;

  function CalcularDigito1(ChaveASBACESemDigito: string): integer;
   {
    Calcula o primeiro d�gito.
    O c�lculo � parecido com o da rotina Modulo10. Por�m, n�o faz diferen�a o
    n�mero de d�gitos de cada subproduto.
    Se o resultado da opera��o for 0 (ZERO) o d�gito ser� 0 (ZERO). Caso contr�rio,
    o d�gito ser� igual a 10 - Resultado.
   }
  var
    Auxiliar, Soma, Contador, Peso, Digito1: integer;
  begin
    Soma:=0;
    Peso:=2;
    for Contador:=Length(ChaveASBACESemDigito)downto 1 do
    begin
      Auxiliar:=(StrToInt(ChaveASBACESemDigito[Contador])*Peso);
      if Auxiliar>9 then
        Auxiliar:=Auxiliar-9;
      Soma:=Soma+Auxiliar;
      if Peso=1 then
        Peso:=2
      else
        Peso:=1;
    end;

    Digito1:=Soma mod 10;
    if (Digito1=0) then
      Result:=Digito1
    else
      Result:=10-Digito1;
  end;

  function CalcularDigito2(ChaveASBACESemDigito: string; var Digito1: integer):
      integer;
   {Calcula o segundo d�gito}
  var
    Digito2: integer;
    ChaveASBACEComDigito1: string;
  begin
    ChaveASBACEComDigito1:=ChaveASBACESemDigito+IntToStr(Digito1);
    Digito2:=StrToInt(Modulo11(ChaveASBACEComDigito1, 7, true));
    {Se d�gito2 = 1, deve-se incrementar o d�gito1 e recalcular o d�gito2}
    if Digito2=1 then
    begin
      Digito1:=Digito1+1;
         {Se, ap�s incrementar o d�gito1, ele ficar maior que 9, deve-se
          substitu�-lo por 0}
      if Digito1>9 then
        Digito1:=0;
      Digito2:=CalcularDigito2(ChaveASBACESemDigito, Digito1);
    end
    else if Digito2>1 then
    begin
      Digito2:=11-Digito2;
    end;

    Result:=Digito2;
  end;

begin
  Digito1:=CalcularDigito1(ChaveASBACESemDigito);
  Digito2:=CalcularDigito2(ChaveASBACESemDigito, Digito1);

  Result:=IntToStr(Digito1)+IntToStr(Digito2);
end;

function TACBrBanrisul.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras, CampoLivre, Modalidade,digitoVerificador: string;
  DigitoNum: Integer;
begin
  with ACBrTitulo do
  begin
     if ACBrBoleto.Cedente.ResponEmissao = tbCliEmite then
        Modalidade:='2'
     else
        Modalidade:='1';

     FatorVencimento:=CalcularFatorVencimento(ACBrTitulo.Vencimento);

     CampoLivre:= Modalidade +'1'+
                  PadLeft(copy(trim(ACBrBoleto.Cedente.Agencia),1,4), 4, '0')+{ C�digo ag�ncia (cooperativa) }
                  PadLeft(OnlyNumber(ACBrBoleto.Cedente.CodigoCedente), 7, '0')+{ C�digo cedente = codigoCedente }
                  PadLeft(NossoNumero, 8, '0')+{ Nosso n�mero }
                  '40';

     

     DigitoVerificador:= CalculaDigitosChaveASBACE(CampoLivre);

     CampoLivre := CampoLivre + DigitoVerificador;

     
     CodigoBarras:= PadLeft(IntToStr(Numero), 3, '0')+'9'+
                    FatorVencimento+{ Fator de vencimento, n�o obrigat�rio }
                    IntToStrZero(Round(ACBrTitulo.ValorDocumento*100), 10)+{ valor do documento }
                    CampoLivre; { Campo Livre }

     DigitoCodBarras:=CalcularDigitoCodigoBarras(CodigoBarras);
     DigitoNum:=StrToIntDef(DigitoCodBarras, 0);

     if (DigitoNum = 0) or (DigitoNum > 9) then
        DigitoCodBarras:='1';
  end;

  Result:=PadLeft(IntToStr(Numero), 3, '0')+'9'+DigitoCodBarras+Copy(CodigoBarras, 5, 39);
end;

function TACBrBanrisul.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
begin
  Result:=PadLeft(ACBrTitulo.NossoNumero, 8, '0');
  result:=Result+'.'+CalculaDigitosChaveASBACE(Result);
end;

function TACBrBanrisul.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string;
begin
  Result := copy(ACBrTitulo.ACBrBoleto.Cedente.Agencia, 1, 4)+'-'+
            ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito+'/'+
            copy(ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente,1,6) + '.' +
            copy(ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente,7,1) + '.' +
            copy(ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente,8,2);
end;

procedure TACBrBanrisul.GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList);
var
  cd,wLinha: string;
begin
  aTotal:=0;
  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    cd:= OnlyNumber(CodigoCedente);

    wLinha:= '0'                                          + // ID do Registro
             '1'                                          + // ID do Arquivo( 1 - Remessa)
             'REMESSA'                                    + // Literal de Remessa
             space(17)                                    + // Brancos
             PadLeft(copy(trim(Agencia), 1, 4)+cd, 13, '0')  + // C�digo Agencia + Cedente AAAACCCCCCCCC
             space(7)                                     + // Brancos
             PadRight(Nome, 30, ' ')                          + // Nome da empresa Cedente
             PadRight('041BANRISUL', 11)                      + // C�digo e Nome do Banco Constante(041Banrisul)
             space(7)                                     + // Brancos
             FormatDateTime('ddmmyy', Now)                + // Data de grava��o do arquivo
             Space(9)                                     + // Brancos
             space(4)                                     + // C�digo do servi�o - Somente para carteiras R, S e X
             ' '                                          + // Brancos
             space(1)                                     + // Tipo de processamento - Somente para carteiras R, S e X
             ' '                                          + // Brancos
            space(10)                                     + // C�digo do cliente no Office Banking - Somente para carteiras R, S e X
            Space(268)                                    + // Brancos
            IntToStrZero(1, 6);                             // Constante (000001)

    aRemessa.Text := aRemessa.Text + UpperCase(wLinha);
  end;
end;

procedure TACBrBanrisul.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  Ocorrencia, cd, TipoSacado     :String;
  aTipoAceite , aTipoCobranca, TipoBoleto, wLinha :String;
begin
  with ACBrTitulo do
  begin
    {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                        : Ocorrencia:='02'; {Pedido de Baixa}
      toRemessaConcederAbatimento            : Ocorrencia:='04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento            : Ocorrencia:='05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento             : Ocorrencia:='06'; {Altera��o de vencimento}
      toRemessaProtestar                     : Ocorrencia:='09'; {Pedido de protesto}
      toRemessaSustarProtesto                : Ocorrencia:='10'; {Susta��o de protesto}
      //toRemessaCancelarInstrucaoProtestoBaixa: Ocorrencia:='18'; {Sustar protesto e baixar} //---Est�o erradas essas ocorrencias comentadas
      //toRemessaCancelarInstrucaoProtesto     : Ocorrencia:='19'; {Sustar protesto e manter na carteira}
      //toRemessaOutrasOcorrencias             : Ocorrencia:='31'; {Altera��o de Outros Dados}
    else
      Ocorrencia:='01'; {Remessa}
    end;
    
    {Pegando Tipo de Boleto}
    case ACBrBoleto.Cedente.ResponEmissao of
      tbCliEmite    : TipoBoleto:='08';   //Cobran�a credenciada Banrisul
      tbBancoReemite: TipoBoleto:='04'; //Cobran�a Direta
      tbBancoEmite: TipoBoleto:='06'; //Cobran�a Direta
    else
      TipoBoleto:='08'; //Cobran�a credenciada Banrisul
    end;

    { Pegando o Aceite do Titulo }
    case Aceite of
      atSim: ATipoAceite:='A';
      atNao: ATipoAceite:='N';
    end;

    {Pegando Tipo de Sacado}
    case Sacado.Pessoa of
      pFisica  : TipoSacado := '01';
      pJuridica: TipoSacado := '02';
    else
      TipoSacado:='99';
    end;

    { Pegando Tipo de Cobran�a - Tipo de Carteira}
    case CaracTitulo of
      tcSimples: aTipoCobranca := '1';
      //tcDescontada: aTipoCobranca:='';
      tcVendor: aTipoCobranca:='F';
      tcVinculada: aTipoCobranca:='C';
    else
      aTipoCobranca:='1';
    end;

    if CodigoMora='' then
      CodigoMora:='0'; //0-Valor Diario, 1-Taxa Mensal

    {Instru��es}
    if ((DataProtesto <> 0) and (DataProtesto > Vencimento)) then //Se tiver protesto
    begin
      if (Trim(Instrucao1) = '') then
        Instrucao1 := '09';  //Protestar caso impago em NN dias ap�s vencimento.
    end
    else
      Instrucao1 := '23'; //N�o protestar

    if (PercentualMulta > 0) then
    begin
      if (Trim(Instrucao2) = '') then
        Instrucao2 := '18'; //Apos NN dias vencimento com percentual multa
    end;

    with ACBrBoleto do
    begin
      cd:= OnlyNumber(Cedente.CodigoCedente);

      wLinha:= '1'                                                              + // ID Registro(1-Constante)
               space(16)                                                        + // Brancos
               PadLeft(copy(trim(Cedente.Agencia), 1, 4) + cd, 13, '0')            + // Codigo da Agencia e Cedente AAAACCCCCCCCC
               space(7)                                                         + // Brancos
               space(25)                                                        + // Identifica��o do t�tulo para o cedente (usado no arquivo de retorno)
               PadRight(NossoNumero, 8, '0')+CalculaDigitosChaveASBACE(NossoNumero) + // Nosso N�mero
               space(32)                                                        + // Mensagem no bloqueto
               space(3)                                                         + // Brancos
               aTipoCobranca                                                    + // Tipo de Carteira (Simples, Vinculada, Descontada, Vendor)
               Ocorrencia                                                       + // C�digo de ocorr�ncia
               PadRight(NumeroDocumento, 10)                                        + // Seu N�mero
               FormatDateTime('ddmmyy', Vencimento)                             + // Data de vencimento do t�tulo
               IntToStrZero(Round(ValorDocumento*100), 13)                      + // Valor do t�tulo
               '041'                                                            + // Constante (041)
               space(5)                                                         + // Brancos
               TipoBoleto                                                       + // Tipo de Documento (04-Cobran�a Direta, 06-Cobran�a Escritural, 08-Cobran�a credenciada Banrisul, 09-T�tulos de terceiros)
               aTipoAceite                                                      + // C�digo de aceite (A, N)
               FormatDateTime('ddmmyy', DataDocumento)                          + // Data de Emiss�o do t�tulo
               PadLeft(trim(Instrucao1), 2)                                        + // 1� Instru��o
               PadLeft(trim(Instrucao2), 2)                                        + // 2� Instru��o
               PadLeft(trim(CodigoMora), 1)                                        + // C�digo de mora (0=Valor di�rio; 1=Taxa Mensal)
               IntToStrZero(Round(ValorMoraJuros*100), 12)                      + // Valor ao dia ou Taxa Mensal de juros
               IfThen(DataDesconto = 0, '      ',                                 //volmir 27-01-16
                      FormatDateTime('ddmmyy', DataDesconto))                   + // Data para concess�o de desconto
               IntToStrZero(Round(ValorDesconto*100), 13)                       + // Valor do desconto a ser concedido
               IntToStrZero(Round(ValorIOF*100), 13)                            + // Valor IOF (para carteira "X" �: taxa juros + IOF + zeros)
               IntToStrZero(Round(ValorAbatimento*100), 13)                     + // Valor do abatimento
               TipoSacado                                                       + // Tipo do Sacado (01-CPF, 02-CNPJ, 03-Outros)
               PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                        + // N�mero da inscri��o do Sacado (CPF, CNPJ)
               PadRight(Sacado.NomeSacado, 35)                                      + // Nome do Sacado
               space(5)                                                         + // Brancos
               PadRight(Sacado.Logradouro+' '+
                    Sacado.Numero+' '+
                    Sacado.Complemento, 40)                                     + // Endere�o Sacado
               space(7)                                                         + // Brancos
               IntToStrZero(Round( PercentualMulta * 10), 3)                    + // Taxa de multa ap�s o Vencimento -- estava '000' � apenas uma casa decimal
               IfThen((DataMoraJuros <> 0) and (DataMoraJuros > Vencimento),      
                      PadLeft(IntToStr(DaysBetween(DataMoraJuros, Vencimento)),
                      2, '0'), '00')                                                + // N� dias para multa ap�s o vencimento (00 considera-se Ap�s Vencimento)
               PadRight(OnlyNumber(Sacado.CEP), 8, '0')                             + // CEP
               PadRight(Sacado.Cidade, 15)                                          + // Cidade do Sacado
               PadRight(Sacado.UF, 2)                                               + // UF do Sacado
               '0000'                                                           + // Taxa ao dia para pagamento antecipado
               space(1)                                                         + // Brancos
               '0000000000000'                                                  + // Valor para c�lculo de desconto
               IfThen((DataProtesto <> 0) and (DataProtesto > Vencimento),
                      PadLeft(IntToStr(DaysBetween(DataProtesto, Vencimento)),
                      2, '0'), '00')                                            + // Dias para protesto/devolu��o autom�tica
               space(23)                                                        + // Brancos
               IntToStrZero(aRemessa.Count + 1, 6);                               // N�mero sequencial do registro  

      aTotal:=aTotal+ValorDocumento;

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
    end;
  end;
end;

procedure TACBrBanrisul.GerarRegistroTrailler400(ARemessa: TStringList);
var
  wLinha: String;
begin
  wLinha:= '9'                                     + // Constante (9)
           space(26)                               + // Brancos
           FormatCurr('0000000000000', aTotal*100) + // Total Somat�rio dos valores dos t�tulos
           space(354)                              + // Brancos
           IntToStrZero(ARemessa.Count+1, 6);        // N�mero sequencial do Registro

  ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

function TACBrBanrisul.GerarRegistroHeader240(
  NumeroRemessa: Integer): String;
var TipoInsc: String;
begin
  case ACBrBanco.ACBrBoleto.Cedente.TipoInscricao of
     pFisica:   TipoInsc := '1';
     pJuridica: TipoInsc := '2';
  else 
     TipoInsc := '9';
  end;

  with ACBrBanco.ACBrBoleto.Cedente do 
  begin
     Result := '041'+                                             //   1 -   3   C�digo do banco
               DupeString('0', 4) +                               //   4 -   7   Lote de servi�o
               '0' +                                              //   8 -   8   Registro header de arquivo
               Space(9) +                                         //   9 -  17   Uso exclusivo FEBRABAN/CNAB
               TipoInsc +                                         //  18 -  18   Tipo de inscri��o
               OnlyNumber(CNPJCPF) +                              //  19 -  32   N�mero de inscri��o da empresa (N�o considerado)
               PadLeft(OnlyNumber(Convenio), 13, '0') +              //  33 -  45   C�digo do conv�nio
               Space(7) +                                         //  46 -  52   Brancos
               '00'+                                              //  53 -  54   Zeros
               PadLeft(OnlyNumber(Agencia), 3, '0') +                //  55 -  57   Ag�ncia (N�o considerado)
               AgenciaDigito +                                    //  58 -  58   D�gito ag�ncia (N�o considerado)
               PadLeft(OnlyNumber(Conta), 12, '0') +                 //  59 -  70   N�mero da conta (N�o considerado)
               ContaDigito +                                      //  71 -  71   D�gito da conta (N�o considerado)
               Space(1) +                                         //  72 -  72   D�gito verificador da ag�ncia/conta (N�o considerado)
               PadRight(Nome, 30) +                                   //  73 - 102   Nome do cedente
               PadRight(UpperCase(ACBrBanco.Nome), 30) +           // 103 - 132   Nome do banco
               Space(10) +                                        // 133 - 142   Uso exclusivo FEBRABAN/CNAB
               '1'+                                               // 143 - 143   C�digo remessa
               FormatDateTime('ddmmyyyyhhnnss', Now) +            // 144 - 157   Data e hora da gera��o do arquivo
               IntToStrZero(NumeroRemessa, 6) +                   // 158 - 163   N�mero sequencial do arquivo
               '040'+                                             // 164 - 166   N�mero da vers�o do layout do arquivo
               DupeString('0', 5) +                               // 167 - 171   Densidade de grava��o do arquivo
               Space(69);                                         // 172 - 240   Outros campos

     Result := Result + #13#10 +
               '041' +                                            //   1 -   3   C�digo do banco
               '0001' +                                           //   4 -   7   Lote de servi�o
               '1'+                                               //   8 -   8   Registro header de lote
               'R'+                                               //   9 -   9   Tipo de opera��o
               '01'+                                              //  10 -  11   Tipo de servi�o
               '00'+                                              //  12 -  13   Forma de lan�amento
               '020'+                                             //  14 -  16   N�mero da vers�o do layout do lote
               Space(1) +                                         //  17 -  17   Uso exclusivo FEBRABAN/CNAB
               TipoInsc +                                         //  18 -  18   Tipo de inscri��o da empresa
               PadLeft(OnlyNumber(CNPJCPF), 15, '0') +               //  19 -  33   N�mero de inscri��o da empresa
               PadLeft(OnlyNumber(Convenio), 13, '0') +              //  34 -  46   C�digo do conv�nio
               Space(7) +                                         //  47 -  53   Brancos
               PadLeft(OnlyNumber(Agencia), 5, '0') +                //  54 -  58   Ag�ncia
               AgenciaDigito +                                    //  59 -  59   D�gito da ag�ncia
               PadLeft(OnlyNumber(Conta), 12, '0') +                 //  60 -  71   N�mero da conta
               ContaDigito +                                      //  72 -  72   D�gito da conta
               Space(1) +                                         //  73 -  73   D�gito verificador da ag�ncia/conta
               PadLeft(Nome, 30) +                                   //  74 - 103   Nome da empresa
               Space(80) +                                        // 104 - 183   Mensagens
               IntToStrZero(NumeroRemessa, 8) +                   // 184 - 191   N�mero sequencial do arquivo
               FormatDateTime('ddmmyyyy', Now) +                  // 192 - 199   Data de gera��o do arquivo
               DupeString('0', 8) +                               // 200 - 207   Data do cr�dito
               DupeString(' ', 33);                               // 208 - 240   Uso exclusivo FEBRABAN/CNAB
  end;
end;

function TACBrBanrisul.GerarRegistroTrailler240(
  ARemessa: TStringList): String;
var Valor: Currency;
    i, Ps: Integer;
begin
   Valor := 0.00;
   Ps := 1;
   for i := 0 to ARemessa.Count - 1 do 
   begin
      if (ARemessa.Strings[i][14] = 'P') then
         Valor := Valor + (StrToCurr(Copy(ARemessa.Strings[i], 86, 15)) / 100);

      while (Pos('*****', ARemessa.Strings[i]) > 0) do 
      begin
         ARemessa.Strings[i] := StringReplace(ARemessa.Strings[i], '*****', IntToStrZero(Ps, 5), []);
         Inc(Ps);
      end;
   end;
   Result := '04100015'+
             DupeString(' ', 9) +
             IntToStrZero(ARemessa.Count * 2, 6) +
             IntToStrZero(((ARemessa.Count * 2) - 2) div 2, 6) +
             PadLeft(StringReplace(FormatFloat('#####0.00', Valor), ',', '', []), 17, '0') +
             DupeString('0', 77) +
             DupeString(' ', 117);

   Result := Result + #13#10 +
             '04199999' +
             DupeString(' ', 9) +
             '000001' +
             IntToStrZero((ARemessa.Count + 1) * 2, 6) +
             DupeString('0', 6) +
             DupeString(' ', 205);
end;

function TACBrBanrisul.GerarRegistroTransacao240(
  ACBrTitulo: TACBrTitulo): String;
var
    aAceite, DiasProt, Juros, TipoInscSacado, Ocorrencia: String;
begin
   with ACBrTitulo do begin
      case Aceite of
         atSim: aAceite := 'A';
         atNao: aAceite := 'N';
      end;

      DiasProt := '00';

      if (DataProtesto > 0) then
         DiasProt := PadLeft(IntToStr(DaysBetween(Vencimento, DataProtesto)), 2, '0');
       
      if (DiasProt = '00') then
         DiasProt := '0'+ DiasProt
      else 
         DiasProt := '1'+ DiasProt;

      if (DataMoraJuros > 0) then
         Juros := '1'+ FormatDateTime('ddmmyyyy', DataMoraJuros) + PadLeft(StringReplace(FormatFloat('#####0.00', ValorMoraJuros), ',', '', []), 15, '0')
      else
         Juros := DupeString('0', 24);

      case Sacado.Pessoa of
         pFisica:   TipoInscSacado := '1';
         pJuridica: TipoInscSacado := '2';
      end;

      case OcorrenciaOriginal.Tipo of
         toRemessaBaixar:             Ocorrencia := '02'; {Pedido de Baixa}
         toRemessaConcederAbatimento: Ocorrencia := '04'; {Concess�o de Abatimento}
         toRemessaCancelarAbatimento: Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
         toRemessaAlterarVencimento:  Ocorrencia := '06'; {Altera��o de vencimento}
         toRemessaProtestar:          Ocorrencia := '09'; {Pedido de protesto}
         toRemessaCancelarInstrucaoProtestoBaixa: Ocorrencia := '18'; {Sustar protesto e baixar}
         toRemessaCancelarInstrucaoProtesto:     Ocorrencia := '19'; {Sustar protesto e manter na carteira}
         toRemessaOutrasOcorrencias:  Ocorrencia := '31'; {Altera��o de Outros Dados}
      else
         Ocorrencia := '01'; {Remessa}
      end;

      Result := '04100013' +
                DupeString('*', 5) +
                'P ' +
                Ocorrencia +
                DupeString(' ', 20) +
                PadLeft(OnlyNumber(MontarCampoNossoNumero(ACBrTitulo)), 10, '0') +
                DupeString(' ', 10) +
                Carteira +
                '1020' +
                PadRight(NumeroDocumento, 15) +
                FormatDateTime('ddmmyyyy', Vencimento) +
                PadLeft(StringReplace(FormatFloat('#####0.00', ValorDocumento), ',', '', []), 15, '0') +
                '00000002' +
                aAceite +
                FormatDateTime('ddmmyyyy', DataProcessamento) +
                Juros +
                DupeString('0', 39) +
                DupeString(' ', 15) +
                PadRight(NumeroDocumento, 15) +
                DupeString(' ', 10) +
                DiasProt +
                IfThen(RightStr(trim(Instrucao1),1) = '', '1', Instrucao1)  +
                PadLeft(trim(Instrucao2),3,'0') +
                '09' +
                DupeString('0', 10) +' ';

      Result := Result + #13#10 +
                '04100013' +
                DupeString('*', 5) +
                'Q ' +
                Ocorrencia +
                TipoInscSacado +
                PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0') +
                PadRight(Sacado.NomeSacado, 40) +
                PadRight(Sacado.Logradouro, 40) +
                PadRight(Sacado.Bairro, 15) +
                StringReplace(Sacado.CEP, '-', '', []) +
                PadRight(Sacado.Cidade, 15) +
                Sacado.UF +
                DupeString('0', 16) +
                DupeString(' ', 40) +
                '000' +
                DupeString(' ', 28);

      if (PercentualMulta > 0) then
         Result := Result + #13#10 +
                   '04100013' +
                   DupeString('*', 5) +
                   'R ' +
                   Ocorrencia +
                   DupeString('0', 48) +
                   '1' +
                   FormatDateTime('ddmmyyyy', Vencimento) +
                   PadLeft(StringReplace(FormatFloat('#####0.00', PercentualMulta * ValorDocumento / 100), ',', '', []), 15, '0') +
                   DupeString(' ', 90) +
                   DupeString('0', 28) +
                   DupeString(' ', 33);
   end;
end;

procedure TACBrBanrisul.LerRetorno240(ARetorno: TStringList);
var Titulo: TACBrTitulo;
    FSegT, FSegU: String;
    FTituloErro: TStringList;
    Index, IdxMotivo: Integer;
    rCNPJCPF,rCedente,rConvenio: String;
    rAgencia,rAgenciaDigito: String;
    rConta,rContaDigito: String;
begin
  if (StrToInt(Copy(ARetorno.Strings[0], 1, 3)) <> Numero) then
      raise Exception.Create(ACBrStr('"'+ ACBrBanco.ACBrBoleto.NomeArqRetorno +
                                     '" n�o � um arquivo de retorno do(a) '+ UpperCase(Nome)));

  rCedente := trim(copy(ARetorno[0], 73, 30));
  rConvenio      := Copy(ARetorno.Strings[1], 34, 13);
  rAgencia       := Copy(ARetorno.Strings[1], 54,  5);
  rAgenciaDigito := Copy(ARetorno.Strings[1], 59,  1);
  rConta         := Copy(ARetorno.Strings[1], 60, 12);
  rContaDigito   := Copy(ARetorno.Strings[1], 72,  1);

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno.Strings[0], 158, 6), 0);

  ACBrBanco.ACBrBoleto.DataArquivo   := StringToDateTimeDef(Copy(ARetorno.Strings[0], 144, 2) +'/'+
                                                            Copy(ARetorno.Strings[0], 146, 2) +'/'+
                                                            Copy(ARetorno.Strings[0], 148, 4),
                                                            0, 'dd/mm/yyyy');

  ACBrBanco.ACBrBoleto. DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno.Strings[1], 200, 2) +'/'+
                                                               Copy(ARetorno.Strings[1], 202, 2) +'/'+
                                                               Copy(ARetorno.Strings[1], 204, 4),
                                                               0, 'dd/mm/yyyy');

  rCNPJCPF := FormatarCNPJouCPF(OnlyNumber(copy(ARetorno[1], 19, 14)));

  try
    with ACBrBanco.ACBrBoleto do
    begin
      if (not LeCedenteRetorno) and (rCNPJCPF <> Cedente.CNPJCPF) then
         raise Exception.create(ACBrStr('CNPJ\CPF do arquivo inv�lido'));

      if (not LeCedenteRetorno) and ((rAgencia <> OnlyNumber(Cedente.Agencia)) or
         (rConta <> OnlyNumber(Cedente.Conta))) then
          raise Exception.Create(ACBrStr('Agencia\Conta do arquivo inv�lido'));

      Cedente.Nome   := rCedente;
      Cedente.CNPJCPF:= rCNPJCPF;

      case StrToIntDef(Copy(ARetorno.Strings[0], 18, 1),0) of
        1:
         Cedente.TipoInscricao := pFisica;
        else
         Cedente.TipoInscricao := pJuridica;
      end;

      Cedente.Convenio      := rConvenio;
      Cedente.Agencia       := rAgencia;
      Cedente.AgenciaDigito := rAgenciaDigito;
      Cedente.Conta         := rConta;
      Cedente.ContaDigito   := rContaDigito;

      ListadeBoletos.Clear;
    end;

    FTituloErro := TStringList.Create;
    try
      Index := 2;
      while Index < ARetorno.Count - 3 do
      begin
        FSegT := ARetorno.Strings[Index];
        FSegU := ARetorno.Strings[Index + 1];
        if (FSegT[14] <> 'T') then
        begin
          Inc(Index);
          Continue;
        end;

        try
          Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;
          with Titulo do
          begin
            if (FSegT[133] = '1') then
              Sacado.Pessoa := pFisica
            else if (FSegT[133] = '2') then
              Sacado.Pessoa := pJuridica
            else
              Sacado.Pessoa := pOutras;
            case Sacado.Pessoa of
              pFisica:   Sacado.CNPJCPF := Copy(FSegT, 138, 11);
              pJuridica: Sacado.CNPJCPF := Copy(FSegT, 135, 14);
              else
                Sacado.CNPJCPF := Copy(FSegT, 134, 15);
            end;
            Sacado.NomeSacado := Trim(Copy(FSegT, 149, 40));

            NumeroDocumento      := Trim(Copy(FSegT, 59, 15));
            SeuNumero            := NumeroDocumento;
            Carteira             := Copy(FSegT, 58, 1);
            NossoNumero          := Trim(Copy(FSegT, 38, 20));
            Vencimento           := StringToDateTimeDef(Copy(FSegT, 74, 2) +'/'+
                                                        Copy(FSegT, 76, 2) +'/'+
                                                        Copy(FSegT, 78, 4), 0, 'dd/mm/yyyy');
            ValorDocumento       := StrToInt64Def(Copy(FSegT,  82, 15), 0) / 100;
            ValorDespesaCobranca := StrToInt64Def(Copy(FSegT, 199, 15), 0) / 100;
            ValorMoraJuros       := StrToInt64Def(Copy(FSegU,  18, 15), 0) / 100;
            ValorDesconto        := StrToInt64Def(Copy(FSegU,  33, 15), 0) / 100;
            ValorAbatimento      := StrToInt64Def(Copy(FSegU,  48, 15), 0) / 100;
            ValorIOF             := StrToInt64Def(Copy(FSegU,  63, 15), 0) / 100;
            ValorRecebido        := StrToInt64Def(Copy(FSegU,  93, 15), 0) / 100;
            ValorOutrasDespesas  := StrToInt64Def(Copy(FSegU, 108, 15), 0) / 100;
            ValorOutrosCreditos  := StrToInt64Def(Copy(FSegU, 123, 15), 0) / 100;
            DataOcorrencia       := StringToDateTimeDef(Copy(FSegU, 138, 2) +'/'+
                                                        Copy(FSegU, 140, 2) +'/'+
                                                        Copy(FSegU, 142, 4), 0, 'dd/mm/yyyy');
            DataCredito          := StringToDateTimeDef(Copy(FSegU, 146, 2) +'/'+
                                                        Copy(FSegU, 148, 2) +'/'+
                                                        Copy(FSegU, 150, 4), 0, 'dd/mm/yyyy');

            OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(Copy(FSegT, 16, 2), 0));

            IdxMotivo := 214;
            while (IdxMotivo < 223) do
            begin
              if (Copy(FSegT, IdxMotivo, 2) <> '  ') then begin
                Titulo.MotivoRejeicaoComando.Add(Copy(FSegT, IdxMotivo, 2));
                Titulo.DescricaoMotivoRejeicaoComando.Add(
                   CodMotivoRejeicaoToDescricao(Titulo.OcorrenciaOriginal.Tipo, Trim(Copy(FSegT, IdxMotivo, 2))));
              end;
              Inc(IdxMotivo, 2);
            end;
          end;
        except
          FTituloErro.Add(' - Linhas '+ IntToStr(Index) +' e '+ IntToStr(Index + 1));
        end;

        Inc(Index);
      end;

      if (FTituloErro.Count > 0) then
      begin
        raise Exception.Create(ACBrStr('No arquivo de retorno "'+ ACBrBanco.ACBrBoleto.NomeArqRetorno +
                           '", n�o foi poss�vel realizar a leitura do(s) seguinte(s) t�tulo(s):'+ #13#10 +
                           FTituloErro.Text));
      end;
    finally
      FTituloErro.Free;
    end;
  except
    raise Exception.Create(ACBrStr('N�o foi poss�vel realizar a leitura do arquivo de retorno "'+
                       ACBrBanco.ACBrBoleto.NomeArqRetorno +'" do(a) '+ UpperCase(Nome)));
  end;
end;

procedure TACBrBanrisul.LerRetorno400(ARetorno: TStringList);
var Titulo: TACBrTitulo;
    Linha: String;
    CodOcorrencia, IdxMotivo, codMotivo,  ContLinha: Integer;
    rCedente,rConvenio: String;
    rAgencia,rAgenciaDigito: String;
    rConta,rContaDigito: String;
begin
  if (StrToInt(Copy(ARetorno.Strings[0], 77, 3)) <> Numero) then
      raise Exception.Create(ACBrStr('"'+ ACBrBanco.ACBrBoleto.NomeArqRetorno +
                                     '" n�o � um arquivo de retorno do(a) '+ UpperCase(Nome)));

  ContLinha := 0;
  fpTamanhoMaximoNossoNum:=10;

  rCedente       := trim(copy(ARetorno[0], 47, 30));   //Nome da Empresa
  rConvenio      := ''; //N�o possui essa info
  rAgencia       := Copy(ARetorno.Strings[0], 27, 4);
  rAgenciaDigito := ''; //N�o possui essa info
  rConta         := Copy(ARetorno.Strings[0], 31, 9);
  rContaDigito   := ''; //N�o possui essa info
  codMotivo      := 0;

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno.Strings[0], 386, 9), 0);
  ACBrBanco.ACBrBoleto.DataArquivo   := StringToDateTimeDef(Copy(ARetorno.Strings[0], 95, 2) +'/'+
                                                            Copy(ARetorno.Strings[0], 97, 2) +'/'+
                                                            Copy(ARetorno.Strings[0], 99, 2),
                                                            0, 'dd/mm/yy');

  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and ((rAgencia <> OnlyNumber(Cedente.Agencia)) or
    (rConta <> OnlyNumber(Cedente.CodigoCedente))) then
      raise Exception.Create(ACBrStr('Ag�ncia\Conta do arquivo inv�lido'));

    Cedente.Nome   := rCedente;
    Cedente.CNPJCPF:= '';
    {case StrToIntDef(Copy(ARetorno.Strings[0], 18, 1),0) of
      1:
       Cedente.TipoInscricao := pFisica;
      else
       Cedente.TipoInscricao := pJuridica;
    end;}

    Cedente.Convenio      := rConvenio;
    Cedente.Agencia       := rAgencia;
    Cedente.AgenciaDigito := rAgenciaDigito;
    Cedente.Conta         := rConta;
    Cedente.ContaDigito   := rContaDigito;

    ListadeBoletos.Clear;
  end;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha];

    if (Copy(Linha,1,1) <> '1') then
      Continue;

    Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;
    with Titulo do
    begin
      NossoNumero          := Copy(Linha,63,10);
      SeuNumero            := copy(Linha,117,10);
      NumeroDocumento      := copy(Linha,117,10);

      ValorDocumento       := StrToFloatDef(Copy(Linha,153,13),0)/100;
      ValorAbatimento      := StrToFloatDef(Copy(Linha,228,13),0)/100;
      ValorDesconto        := StrToFloatDef(Copy(Linha,241,13),0)/100;
      ValorRecebido        := StrToFloatDef(Copy(Linha,254,13),0)/100;
      ValorMoraJuros       := StrToFloatDef(Copy(Linha,267,13),0)/100;
      ValorOutrosCreditos  := StrToFloatDef(Copy(Linha,280,13),0)/100;    //Multa estava faltando
      //Anderson
      ValorDespesaCobranca := StrToFloatDef(Copy(Linha,176,13),0)/100;
      ValorOutrasDespesas  := StrToFloatDef(Copy(Linha,189,13),0)/100;
      if (StrToIntDef(Copy(Linha,147,6),0) <> 0) then
        Vencimento := StringToDateTimeDef( Copy(Linha,147,2)+'/'+
                                           Copy(Linha,149,2)+'/'+
                                           Copy(Linha,151,2),0, 'DD/MM/YY' );

      if StrToIntDef(Copy(Linha,296,6),0) <> 0 then
        DataCredito:= StringToDateTimeDef( Copy(Linha,296,2)+'/'+
                                          Copy(Linha,298,2)+'/'+
                                          Copy(Linha,300,2),0, 'DD/MM/YY' );

      DataOcorrencia := StringToDateTimeDef( Copy(Linha,111,2)+'/'+
                                            Copy(Linha,113,2)+'/'+
                                            Copy(Linha,115,2),0, 'DD/MM/YY' );

      OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(Copy(Linha,109,2),0));
      CodOcorrencia := StrToIntDef(Copy(Linha,109,2), 0);
      if ((CodOcorrencia = 3) or (CodOcorrencia = 16) or (CodOcorrencia = 18)) then
      begin
        IdxMotivo := 383;   
        while (IdxMotivo < 392) do
        begin
          if (Copy(Linha, IdxMotivo, 2) <> '  ') then
          begin
            MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
            DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, Trim(Copy(Linha, IdxMotivo, 2))));
          end;
          Inc(IdxMotivo, 2);
        end;
      end;
    end;
  end;
end;

function TACBrBanrisul.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: String): String;
begin
  case TipoOcorrencia of

    toRetornoRegistroConfirmado:
    begin
      if (CodMotivo = 'A4') then
        Result := 'Sacado DDA'
      else Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
    end;

    toRetornoLiquidado,
    toRetornoLiquidadoAposBaixaouNaoRegistro:
    begin
      case StrToIntDef(CodMotivo, 0) of
        01: Result := 'Por saldo - Reservado';
        02: Result := 'Por conta (parcial)';
        03: Result := 'No pr�prio banco';
        04: Result := 'Compensa��o Eletr�nica';
        05: Result := 'Compensa��o Convencional';
        06: Result := 'Por meio Eletr�nico';
        07: Result := 'Reservado';
        08: Result := 'Em Cart�rio';
        else Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
      end;
    end;

    toRetornoBaixado:
    begin
      case StrToIntDef(CodMotivo, 0) of
        0:
        begin
          if (CodMotivo = 'AA') then
            Result := 'Baixa por pagamento'
          else Result := '00 - Outros Motivos';
        end;
        09: Result := 'Comandado Banco';
        10: Result := 'Comandado cliente Arquivo';
        11: Result := 'Comandado cliente On-Line';
        12: Result := 'Decurso prazo - cliente';
        else Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
      end;
    end;

    toRetornoTituloEmSer:
    begin
      case StrToIntDef(CodMotivo, 0) of
        70: Result := 'T�tulo n�o selecionado por erro no CNPJ/CPF ou endere�o';
        76: Result := 'Banco aguarda c�pia autenticada do documento';
        77: Result := 'T�tulo selecionado falta seu n�mero';
        78: Result := 'T�tulo rejeitado pelo cart�rio por estar irregular';
        79: Result := 'T�tulo n�o selecionado - pra�a n�o atendida';
        80: Result := 'Cart�rio aguarda autoriza��o para protestar por edital';
        90: Result := 'Protesto sustado por solicita��o do cedente';
        91: Result := 'Protesto sustado por altera��o no vencimento';
        92: Result := 'Aponte cobrado de t�tulo sustado';
        93: Result := 'Protesto sustado por altera��o no prazo do protesto';
        95: Result := 'Entidade P�blica';
        97: Result := 'T�tulo em cart�rio';
        else Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
      end;
    end;

    toRetornoDebitoTarifas:
    begin
      case StrToIntDef(CodMotivo, 0) of
        00:
        begin
          if (CodMotivo = 'AA') then
            Result := 'Tarifa de formul�rio Pr�-Impresso'
          else Result := '00 - Outros Motivos';
        end;
        01: Result := 'Tarifa de extrato de posi��o';
        02: Result := 'Tarifa de manuten��o de t�tulo vencido';
        03: Result := 'Tarifa de susta��o e envio para cart�rio';
        04: Result := 'Tarifa de protesto';
        05: Result := 'Tarifa de outras instru��es';
        06: Result := 'Tarifa de outras ocorr�ncias(Registro/Liquida��o)';
        07: Result := 'Tarifa de envio de duplicata ao sacado';
        08: Result := 'Custas de protesto';
        09: Result := 'Custas de Susta��o de Protesto';
        10: Result := 'Custas do cart�rio distribuidor';
        11: Result := 'Reservado';
        else Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
      end;
    end;

    toRetornoRegistroRecusado:
    begin
      case StrToIntDef(CodMotivo, 0) of
        01: Result := '01-C�digo do Banco inv�lido';
        02: Result := '02-Agencia/Conta/Numero de controle - Invalido cobranca partilhada';
        04: Result := '04-C�digo do movimento nao permitido para a carteira';
        05: Result := '05-C�digo do movimento inv�lido';
        08: Result := '08-Nosso N�mero inv�lido';
        09: Result := '09-Nosso N�mero duplicado';
        10: Result := '10-Carteira inv�lida';
        15: Result := '15-Caracter�sticas da cobran�a incompat�veis - Analisar motivos(*)';
        16: Result := '16-Data de vencimento inv�lida - Analisar motivos(*)';
        17: Result := '17-Data de vencimento anterior a data de emiss�o';
        18: Result := '18-Vencimento fora do prazo de opera��o';
        20: Result := '20-Valor do t�tulo inv�lido (n�o num�rico)';
        21: Result := '21-Esp�cie de t�tulo inv�lida (arquivo de registro)';
        23: Result := '23-Aceite inv�lido - verifica conte�do v�lido';
        24: Result := '24-Data de emiss�o inv�lida - verifica se a data � num�rica e se est� no formato v�lido';
        25: Result := '25-Data de emiss�o posterior � data de processamento';
        26: Result := '26-C�digo de juros de mora inv�lido';
        27: Result := '27-Valor/Taxa de juros de mora inv�lido';
        28: Result := '28-C�digo de desconto inv�lido';
        29: Result := '29-Valor do desconto maior ou igual ao valor do t�tulo';
        30: Result := '30-Desconto a conceder n�o confere - Analisar motivos(*)';
        32: Result := '32-Valor de IOF inv�lido - Analisar motivos(*)';
        33: Result := '33-Valor do abatimento inv�lido - Analisar motivos(*)';
        34: Result := '34-Valor do abatimento maior ou igual ao valor do t�tulo';
        37: Result := '37-C�digo para protesto inv�lido - rejeita o t�tulo se o campo for diferente de branco,0,1 ou 3';
        38: Result := '38-Prazo para protesto inv�lido - se o c�digo for 1 verifica se o campo � num�rico';
        39: Result := '39-Pedido de protesto n�o permitido para o t�tulo - n�o permite protesto para as carteiras R,S,N e X';
        40: Result := '40-T�tulo com ordem de protesto emitida (para retorno de altera��o)';
        41: Result := '41-Pedido de cancelamento/susta��o de protesto inv�lido';
        42: Result := '42-C�digo para baixa/devolu��o ou instru��o inv�lido - verifica se o c�digo � branco,0,1 ou 2';
        43: Result := '43-Prazo para baixa/devolu��o inv�lido - se o c�digo � 1 verifica se o campo prazo � num�rico';
        44: Result := '44-C�digo da moeda inv�lido';
        45: Result := '45-Nome do Pagador inv�lido ou altera��o do Pagador n�o permitida';
        46: Result := '46-Tipo/n�mero de inscri��o do Pagador inv�lido';
        47: Result := '47-Endere�o n�o informado ou altera��o de endere�o n�o permitida';
        48: Result := '48-CEP inv�lido ou altera��o de CEP n�o permitida';
        49: Result := '49-CEP sem pra�a de cobran�a ou altera��o de cidade n�o permitida';
        50: Result := '50-CEP referente a um Banco correspondente';
        52: Result := '52-UF inv�lida ou altera��o de UF n�o permitida';
        53: Result := '53-Tipo/n�mero de inscri��o do Sacador/Avalista inv�lido';
        54: Result := '54-Sacador/Avalista n�o informado - para a esp�cie AD o nome do Sacador � obrigat�rio';
        57: Result := '57-C�digo da multa inv�lido';
        58: Result := '58-Data da multa inv�lida';
        59: Result := '59-Valor/Percentual da multa inv�lido';
        60: Result := '60-Movimento para t�tulo n�o cadastrado - altera��o ou devolu��o';
        62: Result := '62-Tipo de impress�o inv�lido - Segmento 3S - Analisar motivos(*)';
        63: Result := '63-Entrada de t�tulo j� cadastrado';
        79: Result := '79-Data de juros de mora inv�lido - valida data ou prazo na instru��o de juros';
        80: Result := '80-Data do documento inv�lida - valida data ou prazo da instru��o de desconto';
        81: Result := '81-CEP inv�lido do Sacador';
        83: Result := '83-Tipo/n�mero de inscri��o do Sacador inv�lido';
        84: Result := '84-Sacador n�o informado';
        86: Result := '86-Seu n�mero inv�lido (para retorno de altera��o)';
      else
        Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
      end;
    end;
  else
    Result := IntToStrZero(StrToIntDef(CodMotivo, 0), 2) +' - Outros Motivos';
  end;
end;

function TACBrBanrisul.CodOcorrenciaToTipo(
  const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case ACBrBanco.ACBrBoleto.LayoutRemessa of
    {Nem estava sendo utilizada esta fun��o anteriormente, estava implementada
    //function CodOcorrenciaToTipo(const CodOcorrencia: String): TACBrTipoOcorrencia; overload;}
    c240 : begin
      case CodOcorrencia of
        {00:
        begin
          if (CodOcorrencia = 'AA') then
            Result :=  toRetornoOutrasOcorrencias                             //---> Devolu��o, Liquidado Anteriormente (CCB)
          else if (CodOcorrencia = 'AB') then
            Result := toRetornoOutrasOcorrencias                              //---> Cobran�a a Creditar
          else if (CodOcorrencia = 'AC') then
            Result := toRetornoOutrasOcorrencias                              //---> Situa��o do T�tulo - Cart�rio
          else Result := toRetornoOutrasOcorrencias;
        end;}
        02: Result := toRetornoRegistroConfirmado;
        03: Result := toRetornoRegistroRecusado;
        //04: Result :=                                                         ---> Reembolso e Transf. (Desconto-Vendor) ou Transf. de Carteira (Garantia)
        //05: Result :=                                                         ---> Reembolso e Devolu��o Desconto e Vendor.
        06: Result := toRetornoLiquidado;
        07: Result := toRetornoLiquidadoParcialmente;                  //Liquida��o Parcial
        09: Result := toRetornoBaixado;
        11: Result := toRetornoTituloEmSer;
        12: Result := toRetornoRecebimentoInstrucaoConcederAbatimento;
        13: Result := toRetornoRecebimentoInstrucaoCancelarAbatimento;
        14: Result := toRetornoRecebimentoInstrucaoAlterarVencimento;
        //15: Result :=                                                         ---> Confirma��o de Protesto Imediato por Fal�ncia.
        17: Result := toRetornoLiquidadoAposBaixaouNaoRegistro;
        19: Result := toRetornoRecebimentoInstrucaoProtestar;
        20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
        23: Result := toRetornoEncaminhadoACartorio;
        //24: Result :=                                                         ---> Reservado.
        25: Result := toRetornoBaixaPorProtesto;
        26: Result := toRetornoInstrucaoRejeitada;
        //27: Result :=                                                         ---> Confirma��o do pedido de altera��o de outros dados.
        28: Result := toRetornoDebitoTarifas;
        30: Result := toRetornoAlteracaoDadosRejeitados;
      else
        Result := toRetornoOutrasOcorrencias;
      end;
    end;
    c400 : begin
      case CodOcorrencia of
        02: Result := toRetornoRegistroConfirmado;
        03: Result := toRetornoRegistroRecusado;
        04: Result := toRetornoBaixaLiquidadoEdital;
        06: Result := toRetornoLiquidado;
        07: Result := toRetornoLiquidadoParcialmente;
        08: Result := toRetornoBaixadoViaArquivo;
        //09: Result :=                                                         --->Devolucao automatica
        10: Result := toRetornoBaixadoInstAgencia;
        //11 : Result                                                           --->Arquivo Levantamento
        12: Result := toRetornoAbatimentoConcedido;
        13: Result := toRetornoAbatimentoCancelado;
        14: Result := toRetornoVencimentoAlterado;
        15: Result := toRetornoLiquidadoEmCartorio;
        16: Result := toRetornoDadosAlterados;
        18: Result := toRetornoAlteracaoInstrucao;
        19: Result := toRetornoRecebimentoInstrucaoProtestar;
        20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
        //21: Result :=
        22: Result := toRetornoProtestoSustado;

        23: Result := toRetornoEntradaEmCartorio;
        25: Result := toRetornoBaixadoPorDevolucao;
        26: Result := toRetornoDevolvidoPeloCartorio;
        32: Result := toRetornoReembolsoTransferenciaDescontoVendor;
        33: Result := toRetornoReembolsoDevolucaoDescontoVendor;
        34: Result := toRetornoReembolsoNaoEfetuado;
        40: Result := toRetornoBaixaPorProtesto;
        42: Result := toRetornoRecebimentoInstrucaoAlterarDados;
        45: Result := toRetornoSustacaoEnvioCartorio;

      else
        Result := toRetornoOutrasOcorrencias;
      end;
    end;
  end;
end;

function TACBrBanrisul.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
 CodOcorrencia: Integer;
begin
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia),0);
  case ACBrBanco.ACBrBoleto.LayoutRemessa of
    c240: begin
      case CodOcorrencia of
        {Conferir foi usado CNAB400}
        02: Result:='02-Entrada confirmada';
        03: Result:='03-Entrada rejeitada';
        04: Result:='04-Baixa de t�tulo liquidado por edital';
        06: Result:='06-Liquida��o normal' ;
        07: Result:='07-Liquida��o parcial';
        08: Result:='08-Baixa por pagamento, liquida��o de saldo';
        09: Result:='09-Devolu��o autom�tica' ;
        10: Result:='10-Baixado conforme instru��es da ag�ncia' ;
        11: Result:='11-Arquivo levantamento';
        12: Result:='12-Abatimento concedido' ;
        13: Result:='13-Abatimento cancelado' ;
        14: Result:='14-Vencimento alterado' ;
        15: Result:='15-Liquida��o em cart�rio' ;
        16: Result:='16-Altera��o de dados';
        18: Result:='18-Altera��o de instru��es' ;
        19: Result:='19-Confirma��o recebimento instru��o de protesto' ;
        20: Result:='20-Confirma��o recebimento instru��o susta��o de protesto' ;
        21: Result:='21-Aguardando autoriza��o para protesto por edital';
        22: Result:='22-Protesto sustado por altera��o de vencimento e prazo de cart�rio';
        23: Result:='23-Entrada do t�tulo em cart�rio' ;
        25: Result:='25-Devolu��o, liquidado anteriormente' ;
        26: Result:='26-Devolvido pelo cart�rio, erro de informa��o' ;
        30: Result:='30-Cobran�a a creditar(liquida��o em tr�nsito)' ;
        31: Result:='31-T�tulo em tr�nsito pago em cart�rio' ;
        32: Result:='32-Reembolso e tranfer�ncia Desconto e Vendou ou carteira em garantia' ;
        33: Result:='33-Reembolso e devolu��o Desconto e Vendor';
        34: Result:='34-Reembolso n�o efetuado por falta de saldo' ;
        40: Result:='40-Baixa de t�tulos protestados' ;
        41: Result:='41-Despesa de aponte' ;
        42: Result:='42-Altera��o de t�tulo' ;
        43: Result:='43-Rela��o de t�tulos' ;
        44: Result:='44-Manuten��o mensal' ;
        45: Result:='45-Susta��o de cart�rio e envio de t�tulo a cart�rio' ;
        46: Result:='46-Fornecimento de formul�rio pr�-impresso' ;
        47: Result:='47-Confirma��o de entrada - Pagador DDA' ;
        68: Result:='68-Acerto de dados do rateio de cr�dito' ;
        69: Result:='69-Cancelamento dos dados do rateio' ;
      else
        Result := 'Outras ocorr�ncias';
      end;
    end;
    c400: begin
      case CodOcorrencia of
        02: Result:='02-Entrada confirmada';
        03: Result:='03-Entrada rejeitada';
        04: Result:='04-Baixa de t�tulo liquidado por edital';
        06: Result:='06-Liquida��o normal' ;
        07: Result:='07-Liquida��o parcial';
        08: Result:='08-Baixa por pagamento, liquida��o de saldo';
        09: Result:='09-Devolu��o autom�tica' ;
        10: Result:='10-Baixado conforme instru��es da ag�ncia' ;
        11: Result:='11-Arquivo levantamento';
        12: Result:='12-Abatimento concedido' ;
        13: Result:='13-Abatimento cancelado' ;
        14: Result:='14-Vencimento alterado' ;
        15: Result:='15-Liquida��o em cart�rio' ;
        16: Result:='16-Altera��o de dados';
        18: Result:='18-Altera��o de instru��es' ;
        19: Result:='19-Confirma��o recebimento instru��o de protesto' ;
        20: Result:='20-Confirma��o recebimento instru��o susta��o de protesto' ;
        21: Result:='21-Aguardando autoriza��o para protesto por edital';
        22: Result:='22-Protesto sustado por altera��o de vencimento e prazo de cart�rio';
        23: Result:='23-Entrada do t�tulo em cart�rio' ;
        25: Result:='25-Devolu��o, liquidado anteriormente' ;
        26: Result:='26-Devolvido pelo cart�rio, erro de informa��o' ;
        30: Result:='30-Cobran�a a creditar(liquida��o em tr�nsito)' ;
        31: Result:='31-T�tulo em tr�nsito pago em cart�rio' ;
        32: Result:='32-Reembolso e tranfer�ncia Desconto e Vendor ou carteira em garantia' ;
        33: Result:='33-Reembolso e devolu��o Desconto e Vendor';
        34: Result:='34-Reembolso n�o efetuado por falta de saldo' ;
        40: Result:='40-Baixa de t�tulos protestados' ;
        41: Result:='41-Despesa de aponte' ;
        42: Result:='42-Altera��o de t�tulo' ;
        43: Result:='43-Rela��o de t�tulos' ;
        44: Result:='44-Manuten��o mensal' ;
        45: Result:='45-Susta��o de cart�rio e envio de t�tulo a cart�rio' ;
        46: Result:='46-Fornecimento de formul�rio pr�-impresso' ;
        47: Result:='47-Confirma��o de entrada - Pagador DDA' ;
        68: Result:='68-Acerto de dados do rateio de cr�dito' ;
        69: Result:='69-Cancelamento dos dados do rateio' ;
      else
        Result := 'Outras ocorr�ncias';
      end;
    end;
  end;
end;
 

function TACBrBanrisul.TipoOCorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  case ACBrBanco.ACBrBoleto.LayoutRemessa of
    c240: begin
      case TipoOcorrencia of
        {Conferir com manual pois foi baseado no CNAB400}
        toRetornoRegistroConfirmado:                 Result := '02';
        toRetornoRegistroRecusado:                   Result := '03';
        toRetornoLiquidado:                          Result := '06';
        toRetornoLiquidadoParcialmente:              Result := '07';
        toRetornoBaixadoInstAgencia:                 Result := '10';
        toRetornoAbatimentoConcedido:                Result := '12';
        toRetornoAbatimentoCancelado:                Result := '13';
        toRetornoVencimentoAlterado:                 Result := '14';
        toRetornoLiquidadoEmCartorio:                Result := '15';
        toRetornoRecebimentoInstrucaoProtestar:      Result := '19';
        toRetornoRecebimentoInstrucaoSustarProtesto: Result := '20';
        toRetornoEntradaEmCartorio:                  Result := '23';
      else
        Result := '00';
      end;
    end;
    c400:begin
      case TipoOcorrencia of
        toRetornoRegistroConfirmado:                    Result := '02'; //Confirma��o de entrada
        toRetornoRegistroRecusado:                      Result := '03'; //Entrada rejeitada
        toRetornoBaixaLiquidadoEdital:                  Result := '04'; //Baixa de titulo liquidado por edital
        toRetornoLiquidado:                             Result := '06'; //Liquida��o normal
        toRetornoLiquidadoParcialmente:                 Result := '07'; //Liquida��o parcial
        toRetornoBaixadoViaArquivo:                     Result := '08'; //Baixa por pagamento, liquidacao pelo saldo
        toRetornoBaixadoInstAgencia:                    Result := '10'; //Baixado conforme instru��es
        toRetornoAbatimentoConcedido:                   Result := '12'; //Concessao de abatimento
        toRetornoAbatimentoCancelado:                   Result := '13'; //Cancelamento de abatimento
        toRetornoVencimentoAlterado:                    Result := '14'; //Vencimento alterado
        toRetornoLiquidadoEmCartorio:                   Result := '15'; //Pagamento em cartorio
        toRetornoDadosAlterados:                        Result := '16'; //Altera��o de dados
        toRetornoAlteracaoInstrucao:                    Result := '18'; //Altera��o de instru��es
        toRetornoRecebimentoInstrucaoProtestar:         Result := '19'; //Confirma��o de instru��o de protesto
        toRetornoRecebimentoInstrucaoSustarProtesto:    Result := '20'; //Confirma��o de instru��o de sustar protesto
        //21 - Aguardando autoriza��o para protesto por edital
        toRetornoProtestoSustado:                       Result := '22'; //Protesto sustado por altera��o de vencimento e prazo de cart�rio
        toRetornoEntradaEmCartorio:                     Result := '23'; //Confirma��o da entrada em cart�rio
        toRetornoBaixadoPorDevolucao:                   Result := '25'; //Devolu��o, liquidado anteriormente
        toRetornoDevolvidoPeloCartorio:                 Result := '26'; //Devolvido pelo cart�rio - erro de informa��o
        //30 - Cobran�a a creditar (liquida��o em transito) (**)
        //31 - T�tulo em transito pago em cart�rio(**)
        toRetornoReembolsoTransferenciaDescontoVendor:  Result := '32'; //Reembolso e transferencia Desconto e Vendor ou carteira em garantia
        toRetornoReembolsoDevolucaoDescontoVendor:      Result := '33'; //Reembolso e devolu��o Desconto e Vendor
        toRetornoReembolsoNaoEfetuado:                  Result := '34'; //Reembolso n�o efetuado por falta de saldo
        toRetornoBaixaPorProtesto:                      Result := '40'; //Baixa t�tulo protestatos (**)
        //41 - Despesa de aponte (**)
        toRetornoRecebimentoInstrucaoAlterarDados:      Result := '42'; //Altera��o de t�tulo
        //43 - Rela��o de t�tulos
        //44 - Manuten��o mensal
        toRetornoSustacaoEnvioCartorio:                 Result := '45'; //Susta��o de cart�rio e envio de t�tulo a cart�rio
        //46 - Fornecimento de formul�rio pr�-impresso
        //47 - Confirma��o de entrada - Pagador DDA (**)
        //68 - Acerto de dados do rateio de cr�dito
        //69 - Cancelamento dos dados do rateio
        //--(**) Para que sejam informados nos arquivos de retorno, solicitar anteriormente a agencia
      else
        Result := '00';
      end;
    end;
  end;
end;


end.

