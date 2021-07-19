import numpy as np 
import math
import time
import matplotlib.pyplot as plt

def cal_F(u, v, k, f):
	""" 
	Calculate base element of hopf oscillator
	Input:
	Output:
	"""
	return k*(1-u**2-v**2)*u - 2*np.pi*f*v,  k*(1-u**2-v**2)*v + 2*np.pi*f*u

def cal_P_head(post_u, post_v, epsilon, psi):
	"""
	"""
	return epsilon * (post_v*np.cos(psi) - post_u*np.sin(psi))

def cal_P_tail(pre_u, pre_v, epsilon, psi):
	"""
	"""
	return epsilon * (pre_u*np.sin(psi) + pre_v*np.cos(psi))

def cal_P_body(pre_u, pre_v, post_u, post_v, epsilon, psi):
	"""
	"""
	return epsilon * (pre_u*np.sin(psi) + pre_v*np.cos(psi) - post_u*np.sin(psi) + post_v*np.cos(psi))

if __name__ == '__main__':
	
	# initialize output values's placeholder
	# numpy array with shape (int(endtime/step), number of CPGs)
	# to append time axis, use: array_u = np.append(array_u,[[u1,u2,...,u16]], axis=0)
	array_u = np.zeros([1,16])
	array_v = np.zeros([1,16])
	
	# initialize parameter
	k = 10
	f = 1
	endtime = 10
	step = 0.01
	epsilon = 0.8
	psi = 40*np.pi/180
	# A = np.ones((16))
	# A = np.linspace(0.5, 1, 16)
	A = np.random.normal(scale=1, size=(16))
	
	# initial state
	array_u[0][0] = 0
	array_v[0][0] = 0.001

	for idx in range(1,int(endtime/step)):
		state_u = []
		state_v = []
		array_u = np.append(array_u, np.zeros([1,16]), axis=0)
		array_v = np.append(array_v, np.zeros([1,16]), axis=0)
		for i in range(16):
			# compute the base element
			F_u, F_v = cal_F( array_u[idx-1][i], array_v[idx-1][i], k, f)
			# compute new state of ith CPG at time idx*step with newton approximation
			new_u = F_u * step + array_u[idx-1][i]
			if i==0:
				new_v = (F_v + cal_P_head(array_u[idx-1,1], array_v[idx-1,1], epsilon, psi)) * step + array_v[idx-1][i]
			elif i==15:
				new_v = (F_v + cal_P_tail(array_u[idx-1,14], array_v[idx-1,14], epsilon, psi)) * step + array_v[idx-1][i]
			else: 
				new_v = (F_v + cal_P_body(array_u[idx-1,i-1], array_v[idx-1,i-1], array_u[idx-1,i+1], array_v[idx-1,i+1], epsilon, psi)) * step + array_v[idx-1][i]
			
			# create new state vector
			state_u.append(new_u)
			state_v.append(new_v)
		# add new state vector to original placeholder
		array_u[idx] = array_u[idx] + state_u
		array_v[idx] = array_v[idx] + state_v


	legend_list = []
	for i in range(16):
		plt.plot(np.linspace(0, endtime, int(endtime/step)),array_u[:,i]*A[i])
		legend_list.append(str(i+1))
	plt.legend(legend_list)
	plt.grid('on')
	plt.show()