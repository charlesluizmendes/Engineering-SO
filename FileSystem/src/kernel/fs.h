// On-disk file system format.
// Both the kernel and user programs use this header file.

#define ROOTINO  1   // root i-number
#define BSIZE 1024   // block size

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint magic;        // Must be FSMAGIC
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};

#define FSMAGIC 0x10203040

// Endereçamento de blocos de dados por inode:
// 11 diretos, 1 indireto simples e 1 duplamente indireto.
// Mantemos 13 entradas no vetor addrs[] (tamanho igual ao xv6 original).
#define NDIRECT    11
#define NINDIRECT  (BSIZE / sizeof(uint))

// Posições dentro de addrs[]
#define SINDIRECT  (NDIRECT)       // índice do bloco simples-indireto (posição 11)
#define DINDIRECT  (NDIRECT + 1)   // índice do bloco duplamente indireto (posição 12)

// Capacidade máxima em blocos por arquivo
#define MAXFILE    (NDIRECT + NINDIRECT + NINDIRECT * NINDIRECT)

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // Number of links to inode in file system
  uint  size;           // Size of file (bytes)
  // 11 diretos, 1 indireto simples, 1 duplamente indireto = 13 entradas
  uint  addrs[NDIRECT + 2];
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) ((b)/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};
