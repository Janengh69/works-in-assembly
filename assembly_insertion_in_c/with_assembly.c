
#include <stdio.h>
#include <time.h>

int main()
{
	short a = 0;
	int cl = clock();
	int i = 7;
	int d = 1;
	int arr[8];

	printf(" Old array: \n ");
	for (int j = 0; j < 8; j++) {
		arr[j] = j;
		printf(" %d ", arr[j]);
	}
	_asm {
	LN1main:
		//d = i % i
		movsx eax, DWORD PTR i
			shr eax, 1
			// if ( d == 0)
			jc SHORT LN2main
			movsx eax, BYTE PTR i
			mov ecx, DWORD PTR i
			mov DWORD PTR arr[ecx * 4], eax
			jmp SHORT LN3main
			//arr[i] = - i

			LN2main :
		// arr[i] = i 
		mov ebx, 0
			sub ebx, i
			movsx eax, ebx
			mov ecx, DWORD PTR i
			mov DWORD PTR arr[ecx * 4], eax

			LN3main :
		//i--;
		mov eax, DWORD PTR i
			sub eax, 1
			mov DWORD PTR i, eax
			// while (i >= 0)
			cmp DWORD PTR i, 0
			jge SHORT LN1main//hz
	}

	printf("\n New array: \n ");
	for (int j = 0; j < 8; j++) {
		printf(" %d ", arr[j]);
	}

	printf("\nTime of work of programm with assembler %d ms", clock() - cl);
	cl = clock();
	getchar();
	return 0;

}
