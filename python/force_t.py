import time, os, math, scipy
import numpy as np 
from scipy import integrate

def force_t(k, freq, velo, time, q1, q2, p1, p2):
	global v0, ro, Cn, D, L, N, hmax, denta_q, c1, c2, s1, s2, q1_d, q2_d, s

	hmax = 0.1
	v0 = velo
	f = freq
	ro = 1000
	Cn = 2.8
	N = 16
	L = 0.195
	D = L/(N-1)
	Fx = [None]*(N-1)
	Fxs = 0;

	q1_d = k*(1 - q1**2 - p1**2)*q1 - 2*np.pi*f*p1 + 0
	q2_d = k*(1 - q2**2 - p2**2)*q2 - 2*np.pi*f*p2 + 0
	denta_q = q2 - q1 
	print(denta_q)

	s1 = np.sin(q1) 
	s2 = np.sin(q2)
	c1 = np.cos(q1)
	c2 = np.cos(q2)

	for s in range(16-1):
		Fx[s] = integrate.dblquad(lucfx, 0, 1, lambda w_b: 0, lambda w_b: hmax)

	Fx = np.array(Fx)
	Fxs = np.sum(Fx, axis=0)
	return Fxs[0]


def lucfx(w_b, h):
	global D, ro, Cn, c1, c2, s1, s2, q1_d, q2_d, denta_q, v0, s
	delta = np.sqrt(2*D**2*w_b*(w_b-1)*(1 -np.cos(denta_q[s])) + h**2*(np.sin(denta_q[s]))**2 + D**2);
	en_1 = D*(h/D*np.sin(denta_q[s]));
	vn = D*h/delta*(-h/D*v0*np.sin(denta_q[s])+(c1[s]*(1 - w_b) + w_b*c2[s])*(c1[s]*q1_d[s] + (c2[s]*q2_d[s] - c1[s]*q1_d[s])*w_b) + (s1[s]*(w_b -1) - w_b*s2[s])*(-s1[s]*q1_d[s] +(s1[s]*q1_d[s] - s2[s]*q2_d[s])*w_b));
	fn  = -1/2*ro*Cn*en_1*(vn**2)*np.sign(vn);
	# print(vn)
	return fn

if __name__ == '__main__':
	k = 10
	q1 = np.random.rand(15)
	q2 = np.random.rand(15)
	p1 = np.random.rand(15)
	p2 = np.random.rand(15)
	print(force_t(k, freq=1, velo=1, time=1, q1=q1, q2=q2, p1=p1, p2=p2))
