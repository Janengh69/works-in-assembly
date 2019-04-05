#include <stdio.h>
#include <time.h>

int main()
{
	int cl = clock();
	int i = 7;
	int d = 1;
	int arr[8];

	printf(" Old array: \n ");
	for (int j = 0; j < 8; j++) {
		arr[j] = j;
		printf("%d ", arr[j]);
	}
	do {
		d = i % 2;
		if (!d) {
			arr[i] = i;
		}
		else {
			arr[i] = -i;
		}
		i--;
	} while (i >= 0);
	printf("\n New array: \n ");
	for (int k = 0; k < 8; k++) printf("%d ", arr[k]);
	printf("\n");

	printf("\nTime of work of programm without assembler %d ms", clock() - cl);
	cl = clock();
	getchar();
	return 0;

}
