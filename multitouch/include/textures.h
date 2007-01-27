// This code is from http://www.codecolony.de/opengl.htm#TexturesBFC
// by Phillip Crocoll

// should be freely usable, but we should contact him and let him know.


#include <GL\glaux.h>

class COGLTexture
{
public:
	COGLTexture();
	~COGLTexture();

	_AUX_RGBImageRec *Image;
	unsigned int GetID();
	void LoadFromFile(char *filename);
	void SetActive();
	int GetWidth();
	int GetHeight();
private:
	int Width, Height;
	unsigned int ID;
	bool bInitialized;
};

