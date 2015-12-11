/*  Ofront 1.2 -xtspkaem */
#include "SYSTEM.h"
#include "CmdLine.h"
#include "Strings.h"
#include "Files.h"
#include "Console.h"
#include "Ignore.h"
#include "KolFiles.h"
#include "LibC.h"


static CmdLine_String FixName_pathname, FixName_oldname, FixName_newname;


static BOOLEAN FixName_ReplaceHex (CHAR *s, LONGINT s__len, CHAR *res, LONGINT res__len);


/*============================================================================*/

static BOOLEAN FixName_ReplaceHex (CHAR *s, LONGINT s__len, CHAR *res, LONGINT res__len)
{
	INTEGER num, i, j;
	CHAR hexNum[3];
	i = 0;
	j = 0;
	hexNum[2] = 0x00;
	for (;;) {
		if (s[__X(i, s__len)] == '%') {
			if ((LONGINT)(i + 2) < s__len) {
				hexNum[0] = s[__X(i + 1, s__len)];
				hexNum[1] = s[__X(i + 2, s__len)];
				num = Strings_HexToInt((void*)hexNum, 3);
				if (num >= 0 && hexNum[1] != 0x00) {
					res[__X(j, res__len)] = (CHAR)num;
				} else {
					break;
				}
				i += 2;
			} else {
				break;
			}
		} else {
			res[__X(j, res__len)] = s[__X(i, s__len)];
			if (s[__X(i, s__len)] == 0x00) {
				return 1;
			}
		}
		j += 1;
		if ((LONGINT)j == res__len) {
			j -= 1;
			break;
		}
		i += 1;
		if ((LONGINT)i == s__len) {
			res[__X(j, res__len)] = 0x00;
			return 1;
		}
	}
	res[__X(j, res__len)] = 0x00;
	return 0;
}


export main(int argc, char **argv)
{
	__INIT(argc, argv);
	__IMPORT(CmdLine__init);
	__IMPORT(Strings__init);
	__IMPORT(Files__init);
	__IMPORT(Console__init);
	__IMPORT(Ignore__init);
	__IMPORT(KolFiles__init);
	__IMPORT(LibC__init);
	__REGMAIN("FixName", 0);
/* BEGIN */
	Console_WriteStrLn((CHAR*)"FixName v1.0 - a tool to fix UTF-8 & Hex file names", (LONGINT)52);
	Console_WriteStrLn((CHAR*)"(c) VEDAsoft Oberon Club \'15 - http://zx.oberon2.ru", (LONGINT)52);
	Console_WriteLn();
	if (CmdLine_ParamCount != 1) {
		Console_WriteStrLn((CHAR*)"  Usage: FixName pathname", (LONGINT)26);
		Console_WriteStrLn((CHAR*)"         FixName \"path name with spaces\"", (LONGINT)41);
		__HALT(1);
	}
	CmdLine_GetParam(1, (void*)FixName_pathname, 1024);
	if (KolFiles_ExtractFilePath((void*)FixName_pathname, 1024, (void*)FixName_newname, 1024) && FixName_newname[0] != 0x00) {
		if (LibC_chdir((SYSTEM_PTR)((INTEGER)FixName_newname)) != 0) {
			Console_WriteStrLn((CHAR*)"Bad path", (LONGINT)9);
			__HALT(1);
		}
	}
	Ignore_Bool(KolFiles_ExtractFileName((void*)FixName_pathname, 1024, (void*)FixName_oldname, 1024));
	if (Strings_Utf8ToWin1251((void*)FixName_oldname, 1024, (void*)FixName_newname, 1024) && __STRCMP(FixName_oldname, FixName_newname) != 0 || FixName_ReplaceHex((void*)FixName_oldname, 1024, (void*)FixName_newname, 1024) && __STRCMP(FixName_oldname, FixName_newname) != 0) {
		if (Files_RenameFile((void*)FixName_oldname, 1024, (void*)FixName_newname, 1024)) {
			__HALT(0);
		}
		Console_WriteStrLn((CHAR*)"Couldn\'t rename", (LONGINT)16);
		__HALT(1);
	} else {
		Console_WriteStrLn((CHAR*)"Couldn\'t convert", (LONGINT)17);
		__HALT(1);
	}
	__FINI;
}
