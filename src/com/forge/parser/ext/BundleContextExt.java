package com.forge.parser.ext;

import java.util.HashMap;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.BundleContext;

public class BundleContextExt extends AbstractBaseExt {

	public BundleContextExt(BundleContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BundleContext getContext() {
		return (BundleContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bundle());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BundleContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BundleContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void requiredPropertyCheck() {
		BundleContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		propStore.put("propName", ctx.bundle_identifier().extendedContext.getFormattedText());
		for (int i = 0; i < ctx.bundle_properties().size(); i++) {
			ctx.bundle_properties(i).extendedContext.getSemanticInfo(propStore);
		}
		if (!propStore.containsKey("wires")) {
			throw new IllegalStateException("In Bundle " + ctx.bundle_identifier().extendedContext.getFormattedText()
					+ " wire not present in line " + ctx.start.getLine());
		}

	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		BundleContext ctx = getContext();
		String name = ctx.bundle_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"In bundle duplicate  blocks with name " + name + " exists in line " + ctx.start.getLine());
		} else {
			blockNames.add(name);
		}
	}

	@Override
	protected void arrayPropertyCheck(String parentName) {
		BundleContext ctx = getContext();
		String name = ctx.bundle_identifier().extendedContext.getFormattedText();
		super.arrayPropertyCheck(name);
	}

	@Override
	public void getIdentifier(List<String> idList) {
		BundleContext ctx = getContext();
		idList.add(ctx.bundle_identifier().extendedContext.getFormattedText());
	}
}
