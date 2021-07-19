import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from tqdm import tqdm
from hopf import *
from force_t import *

def amplitude_init(min, max):
	# A = np.random.uniform(10,20,16)
	A = min + np.random.sample(max) * min
	A = sorted(A)
	return A

if __name__ == '__main__':
	
	# initialize output values's placeholder
	# numpy array with shape (int(endtime/step), number of CPGs)
	# to append time axis, use: array_u = np.append(array_u,[[u1,u2,...,u16]], axis=0)
	array_u = np.zeros([1,16])
	array_v = np.zeros([1,16])
	
	# initialize parameter
	k = 10
	f = 2
	endtime = 30
	step = 0.01
	epsilon = 0.8
	psi = -5*np.pi/180
	velo = 5
	# A = np.linspace(0.5, 1, 16)
	# A = np.random.normal(scale=1, size=(16))
	A = amplitude_init(5,20)
	# print(A)

	# initial state
	array_u[0][0] = 0
	array_v[0][0] = 0.001

	F_total = []

	print('Calculating...')
	for idx in tqdm(range(1,int(endtime/step))):
		state_u = []
		state_v = []
		array_u = np.append(array_u, np.zeros([1,16]), axis=0)
		array_v = np.append(array_v, np.zeros([1,16]), axis=0)
		for i in range(16):
			# compute the base element
			F_u, F_v = cal_F(array_u[idx-1][i], array_v[idx-1][i], k, f)
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

		# F_total.append(force_t(k, freq=f, velo=velo, time=idx, q1=np.array(state_u[0:15]), q2=np.array(state_u[1:16]), p1=np.array(state_v[0:15]), p2=np.array(state_v[1:16])))
	print('Done!')

	plt.plot(F_total)
	plt.grid('on')
	plt.show()

	# legend_list = []
	# for i in range(16):
	# 	plt.plot(np.linspace(0, endtime, int(endtime/step)),array_u[:,i])
	# 	legend_list.append(str(i+1))
	# plt.legend(legend_list)
	# plt.grid('on')
	# plt.show()



	# fig, ax = plt.subplots()
	# ydata = []
	# xdata = []
	# ln, = plt.plot([],[])

	# def init():
	# 	ax.set_xlim(0, endtime)
	# 	ax.set_ylim(-1.5, 1.5)
	# 	return ln,

	# def animate(i):
	# 	xdata.append(i*step)
	# 	ydata.append(array_u[i,0])
	# 	ln.set_data(xdata,ydata)
	# 	return ln,

	# ani = FuncAnimation(fig, animate, init_func=init, frames=range(int(endtime/step)), blit=True, interval=25)
	# plt.show()

	# plt.plot(range(10), '--ro')
	# plt.show()

	fig, ax = plt.subplots()
	xdata = []
	ln, = plt.plot([],[],'--ro')

	def init():
		ax.set_xlim(-1, 17)
		ax.set_ylim(-50, 50)
		return ln,

	def animate(i):
		xdata = range(16)
		drawlist = [A[j]*array_u[i,j] for j in range(16)]
		ln.set_data(xdata, drawlist)
		print(i*step)
		# if i%5==0:
		# 	print('{:.2f}s F={:.3f} N'.format(i*step, F_total[i]))
		return ln,

	ani = FuncAnimation(fig, animate, init_func=init, frames=range(int(endtime/step)), blit=True, interval=25)
	plt.grid('on')
	plt.show()