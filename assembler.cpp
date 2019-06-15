#include <iostream>
#include <vector>
#include <string>

#define Looking4Dollar 0
#define Looking4Oprand 1
#define Looking4Offset 2


using namespace std;

string Func[] ={ "addi" , "add" , "sub" , "and" , "or" , "xor" , "slt" , "slti" , "mult" , "div" , "lw" , "sw" , "mflo" , "mfhi" , 
					"j" , "jal" , "jr" , "beq", "bne" , "lui" };

string Opcode[] = { "001000" , "100000" , "100010" , "100100" , "100101" , "100110" ,"101010" ,"001010" ,"011000" ,"011010" ,"100011" ,
                    "101011" ,"010000" ,"010001" ,"000010" ,"000011" ,"000111" ,"000100" ,"000101" ,"001111"  } ;

int OpcodeNum[] = { 2, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 0, 0, 1, 2, 2, 1 };

string s;

int s2i(string s){
	int g = 0;
	for(int i=0;i < s.size();i++){
		g *= 10;
		g += s[i] -'0';
	}
	return g;
}

string Int2Bi(int a,int size){
	string S;
	for(int i=0;i < size;i++)
		S += '0';
	for(int i=size - 1;i >= 0;i--){
		S[i] = (char)( (a % 2) + '0' );
		a /= 2;
	}
	return S;
}

string Proceed(int f){
	vector< string > Op;
	string Off;
	string Offset;
	int cnt = 0;
	int State = (cnt < OpcodeNum[f])?Looking4Dollar : Looking4Offset;
	string Ans;
	bool OffSign = false;
	string Oprand;
	for(int i=0;i < s.size();i++){
		if(State == Looking4Dollar){
			if(s[i] == '$'){
				State = Looking4Oprand;
				Oprand.clear();
			}

		}
		else if(State == Looking4Oprand){
			if('0' <= s[i] && s[i] <= '9')
				Oprand += s[i];
			else{
				cnt ++;
				if(cnt < OpcodeNum[f])
					State = Looking4Dollar;
				else
					State = Looking4Offset;
				Op.push_back(Oprand);
			}
		}
		else if(State == Looking4Offset){
			if('0' <= s[i] && s[i] <= '9')
				Offset += s[i];
			if(s[i] == '-')
				OffSign = true;
		}
	}
	Ans = Opcode[f];
	for(int i=0;i < Op.size();i++)
		Ans += Int2Bi( s2i( Op[i] ) , 5);
	if(Offset.size() != 0){
		int g = 32 - Ans.size();
		string h = Int2Bi( s2i( Offset ), g) ;
		if(OffSign){
			for(int i=0;i < h.size();i++)
				h[i] = (char)((1 - (h[i] - '0')) + '0');
			for(int i=h.size()-1;i >= 0;i--)
				if(h[i] == '1')
					h[i] = '0';
				else{
					h[i] = '1';
					break;
				}
		}
		Ans += h;
	}
	else
		for(; Ans.size() < 32; )
			Ans += '0';
	return Ans;
}

int main(){
	while( getline(cin,s) ){
	
		for( int i=0;i < 20;i++ )
			if(Func[i] == s.substr(0,Func[i].size()) && s[Func[i].size()] == ' ' )
				cout << Proceed(i) << endl;
	}
}