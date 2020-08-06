clc;
clear all;
close all;

gSignal = [1 0 0 0]; 				
cInside = [];						
sSignal = [];						

%ПОСТРОЕНИЕ ГРАФИКА ИНФОРМАЦИОННОГО СИГНАЛА A'(t)
FigHandle0 = figure('Position', [0, 100, 700, 700]);
subplot(5, 1, 1);
stem(gSignal, 'linewidth', 3), grid on;
title('Input Information');
xlabel('Number of bit (1...4)'), ylabel('Bit value (0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [0 1 2 3 4], 'XTicklabel', [0 1 2 3 4]);


%КОДИРОВАНИЕ ИНФОРМАЦИОННОГО СИГНАЛА A'(t) ПОМЕХОУСТОЙЧИВЫМ КОДОМ ХЕММИНГА
for i = 1 : length(gSignal)
	cInside(i) = gSignal(i);
end

cTemp = 0;

sSignal(8) = 0;
for i = 1 : 7
	sSignal(i) = cInside(1);
	cTemp = rem(cInside(1) + cInside(2) + cInside(3), 2);
	cInside(1) = cInside(2);
	cInside(2) = cInside(3);
	cInside(3) = cInside(4);
	cInside(4) = cTemp;
	sSignal(8) = rem(sSignal(8) + sSignal(i), 2);
end

%ПОСТРОЕНИЕ ГРАФИКА ПОМЕХОУСТОЙЧИВОГО КОДА НА ВЫХОДЕ КОДЕРА ХЕММИНГА A(t)
subplot(5, 1, 2);
stem(sSignal, 'linewidth', 3), grid on;
title('Information After Coding Hamming Code');
xlabel('Number of bit (1...8)'), ylabel('Bit value (0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [ 1 2 3 4 5 6 7 8], 'XTicklabel', [ 1 2 3 4 5 6 7 8]);

%ДОБАВЛЕНИЕ ОПОРНОГО ДИБИТА
oSignal = [ 1 1 ];   				
frequency = 4000; 					
m = 2;								     
Amplitude = 0.7;					 
Rb = 2000;							   
Tb = 1/Rb;							    
Ts = Tb*m;							    

xSignal = [];
for i = 1 : 2
  xSignal(i) = oSignal(i);
end

for i = 3 : length(sSignal) + 2
  xSignal(i) = sSignal(i - 2); 
end 

%КОДИРОВАНИЕ СИГНАЛА В КОД ГРЕЯ И ФОРМИРОВАНИЕ ПОСЛЕДОВАТЕЛЬНОСТЕЙ B, B1 И B2 
b1 = [];
b2 = [];

for i = 1 : length(xSignal)/2
  b2(i) = rem((((~xSignal(2*i - 1))*(xSignal(2*i)))+((xSignal(2*i - 1))*(~xSignal(2*i)))), 2);
  b1(i) = xSignal(2*i - 1);
end

for i = 1 : length(xSignal)/2
  xSignal(2*i-1) = b1(i);
  xSignal(2*i) = b2(i);
end

%ГРАФИК КОДИРОВАННОЙ КОДОМ ГРЕЯ ПЕРЕДАВАЕМОЙ ПОСЛЕДОВАТЕЛЬНОСТИ B(t)
subplot(5, 1, 3);
stem(xSignal, 'linewidth', 3), grid on;
title('Information Before Transmiting');
xlabel('Number of bit (1...10)'), ylabel('Bit value (0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);

%ГРАФИК ПЕРЕДАВАЕМОЙ ПОСЛЕДОВАТЕЛЬНОСТИ B1
subplot(5, 1, 4);
stem(b1, 'linewidth', 3), grid on;
title('Inphase Bits (b1)');
xlabel('Number of bit (1...5)'), ylabel('Bit value (0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);

%ГРАФИК ПЕРЕДАВАЕМОЙ ПОСЛЕДОВАТЕЛЬНОСТИ B2
subplot(5, 1, 5);
stem(b2, 'linewidth', 3), grid on;
title('Quadrature Bits (b2)');
xlabel('Number of bit (1...5)'), ylabel('Bit value (0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);


FigHandle1 = figure('Position', [0, 100, 700, 700]);

nrzSignal = 2*xSignal-1;
spSignal = reshape(nrzSignal,2,length(xSignal)/2);
table = Tb/1000 : Tb/99 : Tb;

%DQPSK МОДУЛЯЦИЯ ПЕРЕДАВАЕМОГО СООБЩЕНИЯ ПОСТРОЕНИЕ
y = [];								
inphaseSignal = [];					
quadratureSignal = [];				
carrierSignal = [];					
for i = 1 : 1 : length(xSignal)/2
	y1 = Amplitude*spSignal(1,i)*cos(2*pi*frequency*table+((i-1)*(pi/4)));
	y2 = Amplitude*spSignal(2,i)*sin(2*pi*frequency*table+((i-1)*(pi/4)));
	y3 = Amplitude*cos(2*pi*frequency*table);
	inphaseSignal = [inphaseSignal y1];
	quadratureSignal = [quadratureSignal y2];
	carrierSignal = [carrierSignal y3];
	y = [y y1+y2];
end
transmittingSignal = y;
table2 = Tb/1000 : Tb/99 : (Tb*length(xSignal)/2);

%ГРАФИК СИНФАЗНОЙ СОСТАВЛЯЮЩЕЙ СИГНАЛА I(t)
subplot(5, 1, 1);
plot(table2, inphaseSignal, 'r', 'linewidth', 1), grid on;
title('Inphase DQPSK Modulation');
xlabel('T(sec)');
ylabel('A(volt)');

%ГРАФИК КВАДРАТУРНОЙ СОСТАВЛЯЮЩЕЙ СИГНАЛА Q(t)
subplot(5, 1, 2);
plot(table2, quadratureSignal, 'b', 'linewidth', 1), grid on;
title('Quadrature DQPSK Modulation');
xlabel('T(sec)');
ylabel('A(volt)');

table3 = Tb/1000 : Ts/99 : (Tb*length(xSignal));

%ГРАФИК МОДУЛИРОВАННОГО СИГНАЛА U(t)
subplot(5, 1, 3);
plot(table3, transmittingSignal, 'k', 'linewidth', 2), grid on;
title('DQPSK Modulation Signal (Sum of Inphase and Quadrature Phase Signal)');
xlabel('T(sec)');
ylabel('A(volt)');

%DQPSK ДЕМОДУЛЯЦИЯ ПЕРЕДАВАЕМОГО СООБЩЕНИЯ ПОСТРОЕНИЕ
FigHandle2 = figure('Position', [0, 100, 700, 700]);

receivedData = [];
receivedSignal = transmittingSignal;
b1 = [];
b2 = [];

for i = 1 : 1 : length(xSignal)/2
	inphaseDetector = receivedSignal((i-1)*length(table)+1 : i*length(table)).*cos(2*pi*frequency*table+((i-1)*(pi/4)));
	inphaseDetectorIntegrated = (trapz(table, inphaseDetector))*(2/Tb);
	if inphaseDetectorIntegrated > 0
		receivedInphaseData = 1;
	else
		receivedInphaseData = 0;
	end
	quadratureDetector = receivedSignal((i-1)*length(table)+1 : i*length(table)).*sin(2*pi*frequency*table+((i-1)*(pi/4)));
	quadratureDetectorIntegrated = (trapz(table, quadratureDetector))*(2/Tb);
	if quadratureDetectorIntegrated > 0
		receivedQuadratureData = 1;
	else
		receivedQuadratureData = 0;
	end
	receivedData = [receivedData receivedInphaseData receivedQuadratureData];
  b1 = [ b1 receivedInphaseData];
  b2 = [ b2 receivedQuadratureData]
end

%ГРАФИК ПОЛУЧЕННОЙ ПОСЛЕДОВАТЕЛЬНОСТИ B1(t)
subplot(5, 1, 1);
stem(b1, 'linewidth', 3)
title('Inphase Bits (b1)');
xlabel('Number of bit (1...5)'), ylabel('Bit value(0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);

%ГРАФИК ПОЛУЧЕННОЙ ПОСЛЕДОВАТЕЛЬНОСТИ B2(t)
subplot(5, 1, 2);
stem(b2, 'linewidth', 3)
title('Quadrature Bits (b2)');
xlabel('Number of bit (1...5)'), ylabel('Bit value(0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);

%ГРАФИК ПОЛУЧЕННОЙ ПОСЛЕДОВАТЕЛЬНОСТИ B(t)
subplot(5, 1, 3);
stem(receivedData, 'linewidth', 3)
title('Information After Receiveing');
xlabel('Number of bit (1...10)'), ylabel('Bit value(0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);

b1 = [];
b2 = [];
for i = 1 : length(receivedData)/2
  b2(i) = rem((((~xSignal(2*i - 1))*(xSignal(2*i)))+((xSignal(2*i - 1))*(~xSignal(2*i)))), 2);
  b1(i) = (xSignal(2*i - 1));
end

for i = 1 : length(receivedData)/2
  receivedData(2*i-1) = b1(i);
  receivedData(2*i) = b2(i);
end


for i = 3 : length(receivedData)
  sSignal(i-2) = receivedData(i);
end

sSignal(1) = ~sSignal(1);

%ГРАФИК ПОЛУЧЕННОЙ ПОСЛЕДОВАТЕЛЬНОСТИ A(t) С ВНЕСЕННОЙ В ПЕРВЫЙ БИТ ОШИБКОЙ
subplot(5, 1, 4);
stem(sSignal, 'linewidth', 3)
title('Information View In Hamming Code');
xlabel('Number of bit (1...8)'), ylabel('Bit value(0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);

%ПРОВЕРКА НА НАЛИЧИЕ ОШИБОК И ИХ ИСПРАВЛЕНИЕ ДЛЯ ПОМЕХОУСТОЙЧИВОГО КОДА ХЕММИНГА
vDecode = [];
vDecode = sSignal;
cOdd = 0;
Syn = [];
tSyn = [7 6 4 5 1 3 2];

for i = 1 : 8
	cOdd = rem(cOdd + vDecode(i), 2);
end

if (cOdd = 1)
	Syn(1) = rem(vDecode(1) + vDecode(2) + vDecode(3) + vDecode(5), 2);
	Syn(2) = rem(vDecode(2) + vDecode(3) + vDecode(4) + vDecode(6), 2);
	Syn(3) = rem(vDecode(1) + vDecode(2) + vDecode(4) + vDecode(7), 2);
	cSyn = Syn(3) + 2 * Syn(2) + 4 * Syn(1);
	vAdd = [0 0 0 0 0 0 0 0];
  if(cSyn ~= 0)
	  vAdd(tSyn(cSyn)) = 1;
  end
	for i = 1 : 8
		vDecode(i) = rem((vDecode(i) + vAdd(i)), 2);
	end
end

FinalResult = [];						

for i = 1 : 4
	FinalResult(i) = vDecode(i);
end

%ГРАФИК ИСПРАВЛЕНОЙ ПОЛУЧЕННОЙ ПОСЛЕДОВАТЕЛЬНОСТИ A'(t)
subplot(5, 1, 5);
stem(FinalResult, 'linewidth', 3)
title('Information After Correct Mistakes');
xlabel('Number of bit (1...4)'), ylabel('Bit value(0 or 1)');
set(gca, 'YTick', [0 1], 'YTicklabel', [0 1]);
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10], 'XTicklabel', [1 2 3 4 5 6 7 8 9 10]);