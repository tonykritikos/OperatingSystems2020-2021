#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <signal.h>
#include <ctype.h>
#include <pthread.h>
#include <sys/wait.h> 
#include <unistd.h> 


struct Str{
	FILE* str_file;
	char str_filename;
} *args;


pthread_mutex_t lock;


void signal_handler(int signum){
	
	signal(SIGINT, SIG_IGN);
	signal(SIGTERM, SIG_IGN);
	printf("\nYou ain't gonna kill me!\n");
	return;
}


void* dathread ( void * filename ) {
	
	FILE* fn = (FILE*) filename;
	FILE* file = fopen(filename, "r");
	int c;
	int words = 0;
	while ((c = getc(file)) != EOF){
		if ( c == EOF )
			break;
		if (isspace(c))
			words++;
	}
	
	pthread_mutex_lock(&lock); 
	FILE* records = fopen("records.txt","a");
	char data[1000];
	sprintf(data, "%d %s %d\n", getpid(), filename, words);
	fputs(data, records);
	fclose(records);
	fclose(file);
	pthread_mutex_unlock(&lock); 
	return NULL;

}


int main(int argc, char* argv[]){
	
	if ((signal(SIGINT, signal_handler) == SIG_ERR) || (signal(SIGTERM, signal_handler))  == SIG_ERR){
		printf("Well... You killed me!\n");
	}
	DIR* dir;
	struct dirent* entry;
	pid_t pid;
	
	if (argc < 2)
		argv[1] = ".";
	
	if ((dir = opendir(argv[1])) != NULL) {
		while ((entry = readdir(dir)) != NULL ) {
			if (entry->d_type == DT_DIR)
				continue;	
			
			if((pid = fork()) == 0){
				char filename[1000];
				sprintf(filename, "%s/%s", argv[1], entry->d_name);
				FILE* file = fopen(filename, "r");
				if (file != NULL){
					
					pthread_t thread;
					pthread_create(&thread, NULL, *dathread, (void *) filename);
					pthread_join(thread, NULL);	
					
				}
				fclose(file);
				memset(filename, 0, 1000);
				return(0);
			}	
		}
		closedir(dir);
		wait(NULL);
	}
	else
	{
		perror("That's not a folder!");
		return EXIT_FAILURE;
	}
}
