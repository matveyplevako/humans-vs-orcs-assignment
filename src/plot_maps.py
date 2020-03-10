import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np
import os
import re



def plot_map_and_solution(algo_name, number, solve=False, size=10):

	data = np.zeros((size, size))

	map_name = f'/{algo_name}/{number}'


	def plot_solution(data, map_name):
		with open(f'maps/{map_name}_solution.txt') as file:
			path = file.readline()[1:-1]
			for point in re.findall('\[(.+?), (.+?)\]', path):
				i, j = map(int, point)
				data[i][j] = 5



	with open(f'maps/{map_name}_map.txt') as file:
		for ind, line in enumerate(map(lambda x: x.strip().replace('S', '4'), file.readlines())):
			for char_ind, point in enumerate(line):
				data[ind][char_ind] = int(point)




	cmap = colors.ListedColormap(['white', 'blue', 'green', 'yellow', 'orange', 'red'])
	bounds=[0, 1, 2, 3, 4, 5]
	norm = colors.BoundaryNorm(bounds, cmap.N)

	img = plt.imshow(data, interpolation='nearest', origin='lower',
	                    cmap=cmap, norm=norm)

	if not os.path.exists(f'plots/{algo_name}'):
		os.mkdir(f'plots/{algo_name}/')

	plt.savefig(f'plots/{map_name}_map.png')


	if solve:
		plot_solution(data, map_name)
		img = plt.imshow(data, interpolation='nearest', origin='lower',
		                    cmap=cmap, norm=norm)

		plt.savefig(f'plots/{map_name}_solution.png')

for i in range(1, 5):
	plot_map_and_solution('random_search_success', i, solve=True)

for i in range(1, 5):
	plot_map_and_solution('random_search_fail', i, solve=False)

for i in range(1, 5):
	plot_map_and_solution('backtracking_success', i, solve=True, size=5)

for i in range(1, 4):
	plot_map_and_solution('backtracking_fail', i, solve=False, size=5)


for i in range(1, 5):
	plot_map_and_solution('optimized_backtracking_success', i, solve=True)

for i in range(1, 4):
	plot_map_and_solution('optimized_backtracking_fail', i, solve=False)