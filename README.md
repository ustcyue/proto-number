# proto-number

This is a vim plugin for automatically renumber proto sequence number in a message.
Note: requires python3 support in vim

# Install

## installation via package manager

### Installation with Vundle
put
```
Plugin 'ustcyue/proto-number'
``` 
into your .vimrc

### Installation with Vim-Plug

put
```
Plug 'ustcyue/proto-number'
```
into your .vimrc

# Usage

take the following proto message for example:

```
message Request {
    int64 a = 1;
    int64 b = 2;
    bool c = 3;
    int32 d = 4;
}
```

now, let's say you want to insert one more field between b and c, what you can do is assiagn an arbitrary sequence number for this new field, such as 

```
message Request {
    int64 a = 1;
    int64 b = 2;
    string b2 = 3;
    bool c = 3;
    int32 d = 4;
}
```

then put your cursor any location inside this message and run `ProtoReNumber`, it will be automatically reformatted into
```
message Request {
    int64 a = 1;
    int64 b = 2;
    string b2 = 3;
    bool c = 4;
    int32 d = 5;
}
```
