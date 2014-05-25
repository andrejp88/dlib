/*
Copyright (c) 2011-2014 Timur Gafarov 

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module dlib.image.color;

private
{
    import dlib.math.vector;
    import dlib.math.utils;
}

enum Channel
{
    R = 0,
    G = 1,
    B = 2,
    A = 3
}

alias Vector!(ushort, 4) Color4;
alias Color4 ColorRGBA;

Color4 invert(Color4 c)
{
    return Color4(
        cast(ushort)(255 - c.r), 
        cast(ushort)(255 - c.g), 
        cast(ushort)(255 - c.b), 
        c.a);
}

struct Color4f
{
    Vector4f vec;
    alias vec this;
    
    this(Color4 c, uint bitDepth = 8)
    {
        float maxv = (2 ^^ bitDepth) - 1;
        vec.r = c.r / maxv;
        vec.g = c.g / maxv;
        vec.b = c.b / maxv;
        vec.a = c.a / maxv;
    }
    
    this(Color4f c)
    {
        vec = c.vec;
    }

    this(Vector4f v)
    {
        vec = v;
    }
    
    this(Vector3f v)
    {
        vec = Vector4f(v.x, v.y, v.z, 1.0f);
    }
    
    this(float cr, float cg, float cb, float ca = 1.0f)
    {
        vec = Vector4f(cr, cg, cb, ca);
    }

    static Color4f zero()
    {
        return Color4f(0.0f, 0.0f, 0.0f, 0.0f);
    }

    Color4f opAssign(Vector4f v)
    {
        vec = v;
        return this;
    }

    Color4f opAdd(float x)
    {
        return Color4f(this.vec + x);
    }

    Color4f opSub(float x)
    {
        return Color4f(this.vec - x);
    }

    Color4f opMul(float x)
    {
        return Color4f(this.vec * x);
    }

    Color4f opDiv(float x)
    {
        return Color4f(this.vec / x);
    }

    Color4f opAdd(Vector4f v)
    {
        return Color4f(this.vec + v);
    }

    Color4f opSub(Vector4f v)
    {
        return Color4f(this.vec - v);
    }

    Color4f opMul(Vector4f v)
    {
        return Color4f(this.vec * v);
    }

    Color4f opDiv(Vector4f v)
    {
        return Color4f(this.vec / v);
    }

    Color4 convert(int bitDepth)
    {
        float maxv = (2 ^^ bitDepth) - 1;
        return Color4(
            cast(ushort)(r.clamp(0.0f, 1.0f) * maxv),
            cast(ushort)(g.clamp(0.0f, 1.0f) * maxv),
            cast(ushort)(b.clamp(0.0f, 1.0f) * maxv),
            cast(ushort)(a.clamp(0.0f, 1.0f) * maxv)
        );
    }
    
    int opCmp(ref const(Color4f) c) const
    {
        return cast(int)((luminance() - c.luminance()) * 100);
    }

    float luminance() const
    {
        return (
            vec.arrayof[0] * 0.3f + 
            vec.arrayof[1] * 0.59f + 
            vec.arrayof[2] * 0.11f
        );
    }

    @property Color4f inverse()
    {
        return Color4f(
            1.0f - vec.r,
            1.0f - vec.g,
            1.0f - vec.b, 
            vec.a);
    }

    @property Color4f clamped(float minv, float maxv)
    {
        return Color4f(
            vec.r.clamp(minv, maxv),
            vec.g.clamp(minv, maxv),
            vec.b.clamp(minv, maxv),
            vec.a.clamp(minv, maxv)
        );
    }
}

Color4f packNormal(Vector3f n)
{
    return Color4f((n + 1.0f) * 0.5f);
}

alias Color4f ColorRGBAf;

/*
 * 32-bit color unpacking
 */
Color4f color3(int hex)
{
    ubyte r = (hex >> 16) & 255;
    ubyte g = (hex >> 8) & 255;
    ubyte b = hex & 255;
    return Color4f(
        cast(float)r / 255.0f, 
        cast(float)g / 255.0f,
        cast(float)b / 255.0f);
}

Color4f color4(int hex)
{
    ubyte r = (hex >> 24) & 255;
    ubyte g = (hex >> 16) & 255;
    ubyte b = (hex >> 8) & 255;
    ubyte a = hex & 255;
    return Color4f(
        cast(float)r / 255.0f, 
        cast(float)g / 255.0f,
        cast(float)b / 255.0f,
        cast(float)a / 255.0f);
}

