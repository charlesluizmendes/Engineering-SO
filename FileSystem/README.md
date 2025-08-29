Makefile:

$U/_symlinktest\

kernel/fcntl.h:

#define O_NOFOLLOW 0x1000

kernel/file.h:

uint addrs[NDIRECT + 2]; // idem ao dinode

kernel/fs.c:

static uint
bmap(struct inode *ip, uint bn)
{
  uint addr;
  struct buf *bp, *bp2;
  uint *a;

  if(bn < NDIRECT){
    // direto
    if((addr = ip->addrs[bn]) == 0){
      addr = balloc(ip->dev);
      ip->addrs[bn] = addr;
    }
    return addr;
  }

  // indireto simples
  bn -= NDIRECT;
  if(bn < NINDIRECT){
    // aloca bloco indireto, se preciso
    if((addr = ip->addrs[SINDIRECT]) == 0){
      addr = balloc(ip->dev);
      ip->addrs[SINDIRECT] = addr;
    }
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      addr = balloc(ip->dev);
      a[bn] = addr;
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }

  // duplamente indireto
  bn -= NINDIRECT;
  if(bn < NINDIRECT * NINDIRECT){
    // aloca bloco duplamente indireto, se preciso
    if((addr = ip->addrs[DINDIRECT]) == 0){
      addr = balloc(ip->dev);
      ip->addrs[DINDIRECT] = addr;
    }

    // 1º nível: vetor de ponteiros para blocos indiretos
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    uint i1 = bn / NINDIRECT;
    uint i2 = bn % NINDIRECT;

    if(a[i1] == 0){
      a[i1] = balloc(ip->dev);   // aloca bloco indireto do segundo nível
      log_write(bp);
    }
    uint addr_ind = a[i1];
    brelse(bp);

    // 2º nível: bloco indireto tradicional que aponta para dados
    bp2 = bread(ip->dev, addr_ind);
    a = (uint*)bp2->data;
    if(a[i2] == 0){
      a[i2] = balloc(ip->dev);
      log_write(bp2);
    }
    uint addr_data = a[i2];
    brelse(bp2);
    return addr_data;
  }

  panic("bmap: out of range");
}

void
itrunc(struct inode *ip)
{
  struct buf *bp, *bp2;
  uint *a;

  // diretos
  for(int i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  // indireto simples
  if(ip->addrs[SINDIRECT]){
    bp = bread(ip->dev, ip->addrs[SINDIRECT]);
    a = (uint*)bp->data;
    for(int j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[SINDIRECT]);
    ip->addrs[SINDIRECT] = 0;
  }

  // duplamente indireto
  if(ip->addrs[DINDIRECT]){
    bp = bread(ip->dev, ip->addrs[DINDIRECT]);
    a = (uint*)bp->data;
    for(int i = 0; i < NINDIRECT; i++){
      if(a[i]){
        // liberar lista do indireto de 2º nível
        bp2 = bread(ip->dev, a[i]);
        uint *b = (uint*)bp2->data;
        for(int j = 0; j < NINDIRECT; j++){
          if(b[j])
            bfree(ip->dev, b[j]);
        }
        brelse(bp2);
        bfree(ip->dev, a[i]);
      }
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[DINDIRECT]);
    ip->addrs[DINDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
}

kernel/fs.h:

#define NDIRECT    11

define SINDIRECT  (NDIRECT)       // índice do bloco simples-indireto (posição 11)
#define DINDIRECT  (NDIRECT + 1)   // índice do bloco duplamente indireto (posição 12)

// Capacidade máxima em blocos por arquivo
#define MAXFILE    (NDIRECT + NINDIRECT + NINDIRECT * NINDIRECT)

struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // Number of links to inode in file system
  uint  size;           // Size of file (bytes)
  // 11 diretos, 1 indireto simples, 1 duplamente indireto = 13 entradas
  uint  addrs[NDIRECT + 2];
};

kernel/stat.h:

#define T_SYMLINK 4

kernel/syscall.c:

extern uint64 sys_symlink(void);

[SYS_symlink] sys_symlink

static uint64 (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
[SYS_symlink] sys_symlink
};

kernel/syscall.h:

#define SYS_symlink 22

kernel/sysfile.c:

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    // Já existe uma entrada com esse nome.
    iunlockput(dp);
    ilock(ip);
    // Somente permitir "reabrir" se for criação de arquivo comum
    // e o inode existente for arquivo ou device.
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    goto fail;

  if(type == T_DIR){
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    iupdate(dp);
  }

  iunlockput(dp);

  return ip;

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}

uint64
sys_open(void)
{
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
  if((n = argstr(0, path, MAXPATH)) < 0)
    return -1;

  begin_op();

  if(omode & O_CREATE){
    // criação normal de arquivo regular
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);

    // não pode abrir diretório para escrita
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }

    // Tratamento de symlinks:
    // - Sem O_NOFOLLOW: seguir recursivamente até inode não-symlink (limite 10).
    // - Com O_NOFOLLOW: abrir o próprio symlink (apenas leitura, sem truncar).
    if(ip->type == T_SYMLINK){
      if(omode & O_NOFOLLOW){
        // Abrir o próprio symlink: somente leitura e sem O_TRUNC.
        if((omode & (O_WRONLY | O_RDWR)) || (omode & O_TRUNC)){
          iunlockput(ip);
          end_op();
          return -1;
        }
        // Mantemos ip bloqueado; continua fluxo normal abaixo.
      } else {
        char target[MAXPATH];
        // seguir cadeia de symlinks até atingir alvo não-symlink
        for(int depth = 0; depth < 10 && ip->type == T_SYMLINK; depth++){
          int r = readi(ip, 0, (uint64)target, 0, MAXPATH-1);
          if(r < 0){
            iunlockput(ip);
            end_op();
            return -1;
          }
          target[r] = 0;
          iunlockput(ip);

          if((ip = namei(target)) == 0){
            end_op();
            return -1;
          }
          ilock(ip);
        }
        // se ainda for symlink aqui, estourou profundidade/loop
        if(ip->type == T_SYMLINK){
          iunlockput(ip);
          end_op();
          return -1;
        }

        // Se terminamos num diretório, ainda vale a restrição de escrita
        if(ip->type == T_DIR && omode != O_RDONLY){
          iunlockput(ip);
          end_op();
          return -1;
        }
      }
    }
  }

  // Checagem de device
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  // Só pode truncar arquivos regulares (e apenas depois de resolver symlinks).
  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;
}

uint64
sys_symlink(void)
{
  char target[MAXPATH], path[MAXPATH];
  struct inode *ip;
  int n;

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    return -1;

  begin_op();
  if((ip = create(path, T_SYMLINK, 0, 0)) == 0){
    end_op();
    return -1;
  }

  // ip JÁ ESTÁ com ilock tomado por create()
  n = strlen(target);
  if(writei(ip, 0, (uint64)target, 0, n) != n){
    iunlockput(ip);
    end_op();
    return -1;
  }

  iunlockput(ip);
  end_op();
  return 0;
}

user/user.h:

int symlink(const char *target, const char *path);

user/usys.pl:

entry("symlink");






bigfile
usertests -q
symlinktest