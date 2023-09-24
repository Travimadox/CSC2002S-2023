def calculate_ppm_average(filename):
    with open(filename, 'r') as f:
        # Ignore the first four lines
        for _ in range(4):
            f.readline()
        
        # Initialize variables to hold the sum of RGB values
        total_sum = 0
        new_total_sum = 0  # sum of the modified RGB values
        count = 0  # Count of RGB components
        
        # Read remaining lines and calculate sum
        for line in f:
            value = int(line.strip())
            total_sum += value
            
            # Increase value by 10 and clip at 255
            new_value = min(value + 10, 255)
            new_total_sum += new_value
            
            count += 1
        
        # Calculate the averages
        original_average = total_sum / (count * 255)
        new_average = new_total_sum / (count * 255)
        
        return original_average, new_average

# Example usage
filename = "C:\\Users\\User\\Downloads\\sample_images\\house_64_in_ascii_crlf.ppm"  # Replace this with the name of your PPM file
original_average, new_average = calculate_ppm_average(filename)
print(f"Original average of all RGB components: {original_average}")
print(f"New average of all RGB components: {new_average}")

