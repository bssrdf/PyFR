# -*- coding: utf-8 -*-
<%inherit file='base'/>
<%namespace module='pyfr.backends.base.makoutil' name='pyfr'/>

__global__ void
axnpby(int nrow, int ncolb, int ldim,
       ${', '.join('fpdtype_t* __restrict__ x' + str(i) for i in range(nv))},
       ${', '.join('fpdtype_t a' + str(i) for i in range(nv))})
{
    int j = blockIdx.x*blockDim.x + threadIdx.x;
    int idx;

    if (j < ncolb && a0 == 0.0)
        for (int i = 0; i < nrow; ++i)
        {
        % for k in subdims:
            idx = i*ldim + SOA_IX(j, ${k}, ${ncola});
            x0[idx] = ${pyfr.dot('a{l}', 'x{l}[idx]', l=(1, nv))};
        % endfor
        }
    else if (j < ncolb && a0 == 1.0)
        for (int i = 0; i < nrow; ++i)
        {
        % for k in subdims:
            idx = i*ldim + SOA_IX(j, ${k}, ${ncola});
            x0[idx] += ${pyfr.dot('a{l}', 'x{l}[idx]', l=(1, nv))};
        % endfor
        }
    else if (j < ncolb)
        for (int i = 0; i < nrow; ++i)
        {
        % for k in subdims:
            idx = i*ldim + SOA_IX(j, ${k}, ${ncola});
            x0[idx] = ${pyfr.dot('a{l}', 'x{l}[idx]', l=nv)};
        % endfor
        }
}
