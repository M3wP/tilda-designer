unit FormTildaDesignSelClr;

{$mode ObjFPC}{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
	Buttons, TildaDesignTypes;

type

	{ TTildaDesignSelClrForm }

 TTildaDesignSelClrForm = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		ComboBox1: TComboBox;
		ComboBox2: TComboBox;
		Edit1: TEdit;
		Label1: TLabel;
		Label2: TLabel;
		Label3: TLabel;
		Panel2: TPanel;
		procedure ComboBox1Change(Sender: TObject);
		procedure ComboBox2Change(Sender: TObject);
		procedure Edit1Change(Sender: TObject);
	private
		FSelected: TTildaColour;

	public
		function ShowSelColour(const AColour: TTildaColour): TModalResult;

		property Selected: TTildaColour read FSelected;
	end;

var
	TildaDesignSelClrForm: TTildaDesignSelClrForm;

implementation

{$R *.lfm}

{ TTildaDesignSelClrForm }

procedure TTildaDesignSelClrForm.ComboBox1Change(Sender: TObject);
	var
	v: Integer;

	begin
	ComboBox2.Enabled:= ComboBox1.ItemIndex = 0;
	Edit1.Enabled:= ComboBox1.ItemIndex > 0;

	if  ComboBox1.ItemIndex = 0 then
		FSelected:= TTildaColour(ComboBox2.ItemIndex)
	else
		begin
		if  not TryStrToInt(Edit1.Text, v) then
			v:= 0;

		if  v > 255 then
			v:= 255;

		FSelected:= TTildaColour(Word(ComboBox1.ItemIndex shl 8) or v);
		end;
	end;

procedure TTildaDesignSelClrForm.ComboBox2Change(Sender: TObject);
	begin
	if  ComboBox1.ItemIndex = 0 then
		FSelected:= TTildaColour(ComboBox2.ItemIndex);
	end;

procedure TTildaDesignSelClrForm.Edit1Change(Sender: TObject);
	var
	v: Integer;
	f: Boolean;

	begin
	if  ComboBox1.ItemIndex > 0 then
		begin
		f:= False;

		if  not TryStrToInt(Edit1.Text, v) then
			begin
			v:= 0;
			f:= True;
			end;

		if  v > 255 then
			begin
			v:= 255;
			f:= True;
			end;

		if  f then
			Edit1.Text:= IntToStr(v);

		FSelected:= TTildaColour(Word(ComboBox1.ItemIndex shl 8) or v);
		end;
	end;

function TTildaDesignSelClrForm.ShowSelColour(
		const AColour: TTildaColour): TModalResult;
	var
	domain: TTildaColourDomain;
	val: Byte;

	begin
	domain:= TTildaColourDomain(Word(AColour) shr 8);
	val:= Word(AColour) and $FF;

	ComboBox1.ItemIndex:= Ord(domain);

	if  domain = tcdTheme then
		ComboBox2.ItemIndex:= val
	else
		Edit1.Text:= IntToStr(val);

	ComboBox1Change(Self);

	FSelected:= AColour;

	Result:= ShowModal;
	end;

end.

