#define _UNICODE
#define UNICODE
#include <stdio.h>
#include <windows.h>

typedef struct _REPARSE_DATA_BUFFER {
    ULONG ReparseTag;
    USHORT ReparseDataLength;
    USHORT Reserved;
    union {
        struct {
            USHORT SubstituteNameOffset;
            USHORT SubstituteNameLength;
            USHORT PrintNameOffset;
            USHORT PrintNameLength;
            ULONG Flags; // it seems that the docu is missing this entry (at least 2008-03-07)
            wchar_t PathBuffer[1];
        } SymbolicLinkReparseBuffer;
        struct {
            USHORT SubstituteNameOffset;
            USHORT SubstituteNameLength;
            USHORT PrintNameOffset;
            USHORT PrintNameLength;
            wchar_t PathBuffer[1];
        } MountPointReparseBuffer;
        struct {
            UCHAR DataBuffer[1];
        } GenericReparseBuffer;
    };
} REPARSE_DATA_BUFFER, *PREPARSE_DATA_BUFFER;

#define REPARSE_DATA_BUFFER_HEADER_SIZE FIELD_OFFSET(REPARSE_DATA_BUFFER, GenericReparseBuffer)

int wmain(int argc, wchar_t *argv[])
{
    HANDLE hFile;
    LPCTSTR szMyFile = L"C:\\Documents and Settings"; // Mount-Point (JUNCTION)
    //LPCTSTR szMyFile = _T("C:\\Users\\All Users");  // Symbolic-Link (SYMLINKD)

    hFile = CreateFile(szMyFile, FILE_READ_EA, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OPEN_REPARSE_POINT, NULL);
    if (hFile == INVALID_HANDLE_VALUE) {
        wprintf(L"Could not open dir '%s'; error: %d\n", szMyFile, GetLastError());
        return 1;
    }

    // Allocate the reparse data structure
    DWORD dwBufSize = MAXIMUM_REPARSE_DATA_BUFFER_SIZE;
    REPARSE_DATA_BUFFER *rdata;
    rdata = (REPARSE_DATA_BUFFER *)malloc(dwBufSize);

    // Query the reparse data
    DWORD dwRetLen;
    BOOL bRet = DeviceIoControl(hFile, FSCTL_GET_REPARSE_POINT, NULL, 0,
                                rdata, dwBufSize, &dwRetLen, NULL);
    if (bRet == FALSE) {
        wprintf(L"DeviceIoControl failed with error: %d\n", GetLastError());
        CloseHandle(hFile);
        return 1;
    }
    CloseHandle(hFile);

    if (IsReparseTagMicrosoft(rdata->ReparseTag)) {
        if (rdata->ReparseTag == IO_REPARSE_TAG_SYMLINK) {
            printf("Symbolic-Link\n");
            size_t slen = rdata->SymbolicLinkReparseBuffer.SubstituteNameLength / sizeof(wchar_t);
            wchar_t *szSubName = (wchar_t *)malloc(sizeof(wchar_t) * (slen + 1));
            wcsncpy_s(szSubName, slen + 1, &rdata->SymbolicLinkReparseBuffer.PathBuffer[rdata->SymbolicLinkReparseBuffer.SubstituteNameOffset / sizeof(wchar_t)], slen);
            szSubName[slen] = 0;
            printf("SubstitutionName (len: %d): '%S'\n", rdata->SymbolicLinkReparseBuffer.SubstituteNameLength, szSubName);
            delete[] szSubName;

            size_t plen = rdata->SymbolicLinkReparseBuffer.PrintNameLength / sizeof(wchar_t);
            wchar_t *szPrintName = new wchar_t[plen + 1];
            wcsncpy_s(szPrintName, plen + 1, &rdata->SymbolicLinkReparseBuffer.PathBuffer[rdata->SymbolicLinkReparseBuffer.PrintNameOffset / sizeof(wchar_t)], plen);
            szPrintName[plen] = 0;
            printf("PrintName (len: %d): '%S'\n", rdata->SymbolicLinkReparseBuffer.PrintNameLength, szPrintName);
            delete[] szPrintName;
        } else if (rdata->ReparseTag == IO_REPARSE_TAG_MOUNT_POINT) {
            printf("Mount-Point\n");
            size_t slen = rdata->MountPointReparseBuffer.SubstituteNameLength / sizeof(wchar_t);
            wchar_t *szSubName = new wchar_t[slen + 1];
            wcsncpy_s(szSubName, slen + 1, &rdata->MountPointReparseBuffer.PathBuffer[rdata->MountPointReparseBuffer.SubstituteNameOffset / sizeof(wchar_t)], slen);
            szSubName[slen] = 0;
            printf("SubstitutionName (len: %d): '%S'\n", rdata->MountPointReparseBuffer.SubstituteNameLength, szSubName);
            delete[] szSubName;

            size_t plen = rdata->MountPointReparseBuffer.PrintNameLength / sizeof(wchar_t);
            wchar_t *szPrintName = new wchar_t[plen + 1];
            wcsncpy_s(szPrintName, plen + 1, &rdata->MountPointReparseBuffer.PathBuffer[rdata->MountPointReparseBuffer.PrintNameOffset / sizeof(wchar_t)], plen);
            szPrintName[plen] = 0;
            printf("PrintName (len: %d): '%S'\n", rdata->MountPointReparseBuffer.PrintNameLength, szPrintName);
            delete[] szPrintName;
        } else {
            printf("No Mount-Point or Symblic-Link...\n");
        }
    } else {
        wprintf(L"Not a Microsoft-reparse point - could not query data!\n");
    }
    free(rdata);
    return 0;
}
