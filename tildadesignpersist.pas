unit TildaDesignPersist;

{$mode Delphi}
{$H+}

interface

uses
	Classes, SysUtils, Generics.Collections, DOM;


//		labels: type ident mode
//
//		type:  abstract; mode:  [const, array, struct]

//		data: type value
//
//		type:  string, size, farref, eventref, value, farptr

type
	TTildaPersistMode = (tpmConst, tpmArray, tpmStruct, tpmEvent);

	TTildaPersistent = class;
	TTildaPersistClass = class of TTildaPersistent;

	TTildaReference = class(TObject)
		node: string;
		persistClass: TTildaPersistClass;
		ident: string;
	end;

	TTildaReferences = TObjectList<TTildaReference>;
	TTildaAbstractRefs = TDictionary<TTildaPersistent, TTildaReferences>;

	{ TTildaPersistent }

	TTildaPersistent = class(TObject)
		ident: string;
		mode: TTildaPersistMode;

		procedure PersistState; virtual;

		class function node: string; virtual; abstract;

		procedure ReadFromNode(const ANode: TDomNode); virtual; abstract;
		function  WriteToNode(const ADoc: TDomDocument): TDomElement; virtual;
		procedure WriteToRefNode(const ADoc: TDomDocument;
				const AParent: TDomElement); virtual;
		procedure ApplyReference(const ARef: TTildaReference); virtual; abstract;

		constructor Create(const AIdent: string; const AMode: TTildaPersistMode);
	end;

	TTildaDataType = (tdtSize, tdtString, tdtFarRef, tdtEventRef, tdtFarPtr,
			tdtHexValue, tdtValue);

	{ TTildaDataItem }

	TTildaDataItem = class(TObject)
		name: string;
		dataType: TTildaDataType;
		value: string;

		constructor Create(const AName: string; const AType: TTildaDataType;
				const AValue: string);
	end;

	TTildaPersistLabels = TObjectList<TTildaPersistent>;
	TTildaPersistDataList = TObjectList<TTildaDataItem>;

	TTildaPersistData = TObjectDictionary<TTildaPersistent, TTildaPersistDataList>;

var
	persistents: TTildaPersistLabels;
	persistTemp: TTildaPersistLabels;
	persistData: TTildaPersistData;


implementation


{ TTildaPersistent }

procedure TTildaPersistent.PersistState;
	var
	o: TTildaPersistDataList;

	begin
	persistents.Add(Self);

	o:= TTildaPersistDataList.Create(True);
	persistData.Add(Self, o);
	end;

function TTildaPersistent.WriteToNode(const ADoc: TDomDocument): TDomElement;
	begin
	Result:= ADoc.CreateElement(node);

	Result.SetAttribute('ident', ident);
	end;

procedure TTildaPersistent.WriteToRefNode(const ADoc: TDomDocument;
		const AParent: TDomElement);
	var
	n: TDomElement;

	begin
	n:= ADoc.CreateElement('Ref');

	n.SetAttribute('node', node);
	n.SetAttribute('ident', ident);

	AParent.AppendChild(n);
	end;

constructor TTildaPersistent.Create(const AIdent: string;
		const AMode: TTildaPersistMode);
	begin
	ident:= AIdent;
	mode:= AMode;
	end;


{ TTildaDataItem }

constructor TTildaDataItem.Create(const AName: string;
		const AType: TTildaDataType; const AValue: string);
	begin
	name:= AName;
	dataType:= AType;
	value:= AValue;
	end;

initialization
	persistents:= TTildaPersistLabels.Create;
	persistTemp:= TTildaPersistLabels.Create(True);
	persistData:= TTildaPersistData.Create([doOwnsValues]);


end.

