// Изменения в BranchDetailScreen (lib/views/branch_detail_screen.dart)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../model/branch_model.dart';
import '../viewmodels/branch_detail_view_model.dart';
import 'selected_services_screen.dart';

class BranchDetailScreen extends StatelessWidget {
  final Branch branch;
  const BranchDetailScreen({super.key, required this.branch});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BranchDetailViewModel(branch),
      child: const _BranchDetailView(),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final List<Widget> tabs;

  _SliverTabBarDelegate({required this.tabs});

  @override
  double get minExtent => 48.0;

  @override
  double get maxExtent => 48.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: AppColors.primary),
          insets: EdgeInsets.symmetric(horizontal: 16),
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _BranchDetailView extends StatelessWidget {
  const _BranchDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BranchDetailViewModel>(context);
    return DefaultTabController(
      length: 4,
      initialIndex: vm.currentTabIndex,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(vm.branch.mainPhotoUrl, fit: BoxFit.cover),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.branch.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(vm.branch.location, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('9:00 - 21:00', style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(vm.branch.rating.toString(), style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverTabBarDelegate(
                  tabs: const [
                    Tab(text: 'Services'),
                    Tab(text: 'Package'),
                    Tab(text: 'Specialist'),
                    Tab(text: 'Portfolio'),
                  ],
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              _ServicesTab(branch: vm.branch),
              _PackageTab(branch: vm.branch),
              _SpecialistTab(),
              _PortfolioTab(branch: vm.branch),
            ],
          ),
        ),
        floatingActionButton: (vm.selectedServiceIndices.isNotEmpty || vm.selectedPackageIndices.isNotEmpty)
            ? FloatingActionButton(
          backgroundColor: AppColors.onPrimaryContainer,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectedServicesScreen(
                  branch: vm.branch,
                  selectedServices: vm.selectedServiceIndices,
                  selectedPackages: vm.selectedPackageIndices,
                ),
              ),
            );
          },
          child: const Icon(Icons.arrow_forward, color: AppColors.onPrimary),
        )
            : null,
      ),
    );
  }
}

class _ServicesTab extends StatelessWidget {
  final Branch branch;
  const _ServicesTab({super.key, required this.branch});
  @override
  Widget build(BuildContext context) {
    return Consumer<BranchDetailViewModel>(
      builder: (context, vm, child) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: branch.services.length,
          itemBuilder: (context, index) {
            return _ServiceCard(
              service: branch.services[index],
              isSelected: vm.selectedServiceIndices.contains(index),
              onTap: () => vm.toggleServiceSelection(index),
            );
          },
        );
      },
    );
  }
}

class _PackageTab extends StatelessWidget {
  final Branch branch;
  const _PackageTab({super.key, required this.branch});
  @override
  Widget build(BuildContext context) {
    return Consumer<BranchDetailViewModel>(
      builder: (context, vm, child) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: branch.packages.length,
          itemBuilder: (context, index) {
            return _PackageCard(
              packageItem: branch.packages[index],
              isSelected: vm.selectedPackageIndices.contains(index),
              onTap: () => vm.togglePackageSelection(index),
            );
          },
        );
      },
    );
  }
}

class _PackageCard extends StatelessWidget {
  final PackageItem packageItem;
  final bool isSelected;
  final VoidCallback onTap;
  const _PackageCard({super.key, required this.packageItem, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(packageItem.imageUrl, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(packageItem.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text('${packageItem.price} тг', style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          Center(
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.onPrimaryContainer : Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: Center(
                  child: Icon(isSelected ? Icons.check : Icons.add, color: isSelected ? AppColors.onPrimary : AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialistTab extends StatelessWidget {
  const _SpecialistTab({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BranchDetailViewModel>(context);
    final specialists = vm.branch.stylists;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        final spec = specialists[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage(spec.img)),
            title: Text('${spec.firstname} ${spec.lastname}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(spec.rating.toStringAsFixed(2)),
                const SizedBox(width: 16),
                const Icon(Icons.comment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(spec.commentCount.toString()),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final bool isSelected;
  final VoidCallback onTap;
  const _ServiceCard({super.key, required this.service, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(service.imageUrl, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text('${service.price.toStringAsFixed(0)} тг', style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          Center(
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.onPrimaryContainer : Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: Center(
                  child: Icon(isSelected ? Icons.check : Icons.add, color: isSelected ? AppColors.onPrimary : AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioTab extends StatelessWidget {
  final Branch branch;
  const _PortfolioTab({super.key, required this.branch});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(branch.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(branch.location, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              const Text('9:00 - 21:00', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
              const SizedBox(width: 16),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(branch.rating.toString(), style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Описание филиала, перечень предоставляемых услуг, преимущества и другая информация.',
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
