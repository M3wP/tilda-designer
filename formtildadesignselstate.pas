unit FormTildaDesignSelState;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
	StdCtrls, TildaDesignTypes;

type

	{ TTildaDesignSelStateForm }

	TTildaDesignSelStateForm = class(TForm)
		BitBtn1: TBitBtn;
		BitBtn2: TBitBtn;
		CheckBox1: TCheckBox;
		CheckBox2: TCheckBox;
		Panel2: TPanel;
		procedure CheckBox1Change(Sender: TObject);
		procedure CheckBox2Change(Sender: TObject);
	private
		FSelected: TTildaState;

	public
		function ShowSelSetState(const AState: TTildaState): TModalResult;

		property Selected: TTildaState read FSelected;
	end;

var
	TildaDesignSelStateForm: TTildaDesignSelStateForm;

implementation

{$R *.lfm}

{ TTildaDesignSelStateForm }

procedure TTildaDesignSelStateForm.CheckBox1Change(Sender: TObject);
	begin
	if  CheckBox1.Checked then
		Include(FSelected, tskVisible)
	else
		Exclude(FSelected, tskVisible);
	end;

procedure TTildaDesignSelStateForm.CheckBox2Change(Sender: TObject);
	begin
	if  CheckBox2.Checked then
		Include(FSelected, tskEnabled)
	else
		Exclude(FSelected, tskEnabled);
	end;

function TTildaDesignSelStateForm.ShowSelSetState(const AState: TTildaState): TModalResult;
	begin
	CheckBox1.Checked:= tskVisible in AState;
	CheckBox2.Checked:= tskEnabled in AState;

	FSelected:= AState;

	Result:= ShowModal;
	end;

end.

