package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Package_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Package_identifierContextExt extends AbstractBaseExt {

	public Package_identifierContextExt(Package_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Package_identifierContext getContext() {
		return (Package_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).package_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Package_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Package_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}