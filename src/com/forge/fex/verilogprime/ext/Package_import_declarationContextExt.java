package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Package_import_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Package_import_declarationContextExt extends AbstractBaseExt {

	public Package_import_declarationContextExt(Package_import_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Package_import_declarationContext getContext() {
		return (Package_import_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).package_import_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Package_import_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Package_import_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}