package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Package_or_generate_item_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Package_or_generate_item_declarationContextExt extends AbstractBaseExt {

	public Package_or_generate_item_declarationContextExt(Package_or_generate_item_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Package_or_generate_item_declarationContext getContext() {
		return (Package_or_generate_item_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).package_or_generate_item_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Package_or_generate_item_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Package_or_generate_item_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}