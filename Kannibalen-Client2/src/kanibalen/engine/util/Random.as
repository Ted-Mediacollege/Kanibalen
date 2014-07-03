package kanibalen.engine.util 
{
	public class Random
	{
		private var inext:int;
		private var inextp:int;
		private const MBIG:int = 0x7fffffff;
		private const MSEED:int = 0x9a4ec86;
		private const MZ:int = 0;
		private var seed:int;
		private var seedArray:Vector.<int>;
		
		public function Random(seed:int)
		{
			setSeed(seed);
		}
		
		public function getSeed():int
		{
			return seed;
		}
		
		public function setSeed(s:int):void
		{
			this.seed = seed;
			this.seedArray = new Vector.<int>(0x38, true);
			var num2:int = 0x9a4ec86 - Math.abs(seed);
			this.seedArray[0x37] = num2;
			var num3:int = 1;
			for (var i:int = 1; i < 0x37; i++)
			{
				var index:int = (0x15 * i) % 0x37;
				this.seedArray[index] = num3;
				num3 = num2 - num3;
				if (num3 < 0)
				{
					num3 += 0x7fffffff;
				}
				num2 = this.seedArray[index];
			}
			for (var j:int = 1; j < 5; j++)
			{
				for (var k:int = 1; k < 0x38; k++)
				{
					this.seedArray[k] -= this.seedArray[1 + ((k + 30) % 0x37)];
					if (this.seedArray[k] < 0)
					{
						this.seedArray[k] += 0x7fffffff;
					}
				}
			}
			this.inext = 0;
			this.inextp = 0x15;
			seed = 1;
		}
		
		protected function sample():Number
		{
			return (this.internalSample() * 4.6566128752457969E-10);
		}
		
		private function getSampleForLargeRange():Number
		{
			var num:int = this.internalSample();
			if ((this.internalSample() % 2) == 0)
			{
				num = -num;
			}
			var num2:Number = num;
			num2 += 2147483646.0;
			return (num2 / 4294967293);
		}
		
		private function internalSample():int
		{
			var inext:int = this.inext;
			var inextp:int = this.inextp;
			if (++inext >= 0x38)
			{
				inext = 1;
			}
			if (++inextp >= 0x38)
			{
				inextp = 1;
			}
			var num:int = this.seedArray[inext] - this.seedArray[inextp];
			if (num < 0)
			{
				num += 0x7fffffff;
			}
			this.seedArray[inext] = num;
			this.inext = inext;
			this.inextp = inextp;
			return num;
		}
		
		public function nextInt(max:int):int
		{
			if (max < 0)
			{
				throw new ArgumentError("Argument \"max\" must be positive.");
			}
			return int(this.sample() * max);
		}
		
		public function rangeInt(min:int, max:int):int
		{
			if (min > max)
			{
				throw new ArgumentError("Argument \"min\" must be less than or equal to \"max\".");
			}
			var num:Number = max - min;
			if (num <= 0x7fffffff)
			{
				return (((int) (this.sample() * num)) + min);
			}
			return (((int) (Number(this.getSampleForLargeRange() * num))) + min);
		}
		
		public function nextNumber():Number
		{
			return this.sample();
		}
		
		public function rangeNumber(min:Number, max:Number):int
		{
			if (min > max)
			{
				throw new ArgumentError("Argument \"min\" must be less than or equal to \"max\".");
			}
			var num:Number = max - min;
			if (num <= 0x7fffffff)
			{
				return (((int) (this.sample() * num)) + min);
			}
			return ((Number(this.getSampleForLargeRange() * num)) + min);
		}
	}
}